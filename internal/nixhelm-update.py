import os
import re
import subprocess
import sys

import click
import requests
import semver
import yaml

GIT_PATH = "@git@"
NIX_PATH = "@nix@"
NIX_PREFIX_URL_PATH = "@nix-prefetch-url@"


@click.command()
@click.option("--url", required=True)
@click.option("--chart", required=False)
@click.option("--nix-name", envvar="UPDATE_NIX_NAME")
@click.option("--nix-pname", envvar="UPDATE_NIX_PNAME")
@click.option("--nix-old-version", envvar="UPDATE_NIX_OLD_VERSION")
@click.option("--nix-attr-path", envvar="UPDATE_NIX_ATTR_PATH")
@click.option("--commit", is_flag=True)
@click.option("--dry-run", is_flag=True)
def main(
    url: str,
    chart: str,
    nix_name: str | None,
    nix_pname: str | None,
    nix_old_version: str | None,
    nix_attr_path: str | None,
    commit: bool,
    dry_run: bool,
):
    filename = None

    if nix_attr_path and not filename:
        filename = nix_attr_filename(attr_path=nix_attr_path)

    if not filename:
        raise click.UsageError("filename is required")

    with open(filename, "r") as f:
        content = f.read()

    if not nix_pname:
        nix_pname = os.path.basename(filename).removesuffix(".nix")

    latest: dict = {}

    if url.startswith("oci://"):
        latest = fetch_oci_latest_release(url=url)
    elif url and chart:
        latest = fetch_helm_latest_release(url=url, chart=chart, unpack=True)
    else:
        raise click.UsageError("chart name is required")

    if latest["version"]:
        content = re.sub(
            r'(^\s+version = ")(.+)(")',
            lambda m: m.group(1) + latest["version"] + m.group(3),
            content,
            flags=re.MULTILINE,
        )

    if latest["description"]:
        content = re.sub(
            r'(^\s+description = ")(.+)(")',
            lambda m: m.group(1) + latest["description"] + m.group(3),
            content,
            flags=re.MULTILINE,
        )

    if latest["url"]:
        content = re.sub(
            r'(^\s+url = ")(.+)(")',
            lambda m: m.group(1) + latest["url"] + m.group(3),
            content,
            flags=re.MULTILINE,
        )

    if latest["sha256"]:
        content = re.sub(
            r'(^\s+sha256 = ")(.+)(")',
            lambda m: m.group(1) + latest["sha256"] + m.group(3),
            content,
            flags=re.MULTILINE,
        )

    if nix_old_version and nix_old_version != latest["version"]:
        commit_message = f"{nix_pname}: {nix_old_version} -> {latest['version']}"
    else:
        commit_message = f"{nix_pname}: {latest['version']}"

    if dry_run:
        log(f"cat >{filename} <<EOF")
        log(content)
        log("EOF")
    else:
        with open(filename, "w") as f:
            f.write(content)

    if commit:
        git("add", filename, dry_run=dry_run)
        git("commit", "--message", commit_message, dry_run=dry_run)


def fetch_helm_latest_release(url: str, chart: str, unpack: bool) -> dict:
    base_url = url

    resp = requests.get(f"{url}/index.yaml")
    resp.raise_for_status()
    helm_index = yaml.safe_load(resp.content)

    assert chart in helm_index["entries"], f"Chart {chart} not found in Helm index"

    helm_release = helm_index["entries"][chart][0]

    description = helm_release.get("description")
    version = helm_release.get("version")

    url = helm_release.get("urls", [])[0]
    if not url.startswith("http"):
        url = f"{base_url}/{url}"

    sha256 = None
    if url:
        sha256 = nix_prefetch_url(url=url, unpack=unpack)

    return {
        "description": description,
        "version": version,
        "url": url,
        "sha256": sha256,
    }


def fetch_oci_latest_release(url: str) -> dict:
    url = url.removeprefix("oci://")
    registry, *url_parts = url.split("/")

    if registry == "quay.io":
        base_url = f"https://quay.io/v2/{'/'.join(url_parts)}"
        tags_list_url = f"{base_url}/tags/list"
    else:
        raise ValueError(f"Unsupported registry: {registry}")

    tags_response = requests.get(tags_list_url)
    tags_response.raise_for_status()
    latest_tag = detect_latest_tag(tags_response.json()["tags"])

    manifest_response = requests.get(
        f"{base_url}/manifests/{latest_tag}",
        headers={"Accept": "application/vnd.oci.image.manifest.v1+json"},
    )
    manifest_response.raise_for_status()
    manifest_data = manifest_response.json()

    config_response = requests.get(
        f"{base_url}/blobs/{manifest_data['config']['digest']}",
        headers={"Accept": "application/vnd.cncf.helm.config.v1+json"},
    )
    config_response.raise_for_status()
    config_data = config_response.json()
    description = config_data["description"]

    blob_url = None
    for layer in manifest_data["layers"]:
        if layer["mediaType"] == "application/vnd.cncf.helm.chart.content.v1.tar+gzip":
            blob_url = f"{base_url}/blobs/{layer['digest']}"

    assert blob_url, "No Helm chart found in the OCI image"

    sha256 = None
    if blob_url:
        sha256 = nix_prefetch_url(url=blob_url, unpack=True)

    return {
        "description": description,
        "version": latest_tag,
        "url": blob_url,
        "sha256": sha256,
    }


def detect_latest_tag(tags: list[str]) -> str:
    if "latest" in tags:
        return "latest"

    version_tags: list[str] = []
    for tag in tags:
        if semver.Version.is_valid(tag):
            version = semver.Version.parse(tag)
            if version.prerelease:
                continue
            version_tags.append(tag)
    return max(version_tags, key=semver.Version.parse)


def nix_prefetch_url(url: str, unpack: bool = False) -> str:
    cmd = [NIX_PREFIX_URL_PATH, "--type", "sha256", "--name", "source"]
    if unpack:
        cmd.append("--unpack")
    cmd.append(url)
    log_cmd(cmd)
    result = subprocess.run(cmd, capture_output=True, text=True)
    result.check_returncode()
    return result.stdout.strip()


def nix_current_system() -> str:
    cmd = [NIX_PATH, "eval", "--raw", "--impure", "--expr", "builtins.currentSystem"]
    log_cmd(cmd)
    result = subprocess.run(cmd, capture_output=True, text=True)
    result.check_returncode()
    return result.stdout.strip()


def nix_attr_filename(attr_path: str) -> str:
    system = nix_current_system()
    cmd = [
        NIX_PATH,
        "eval",
        "--raw",
        "--impure",
        f".#packages.{system}.{attr_path}.meta.position",
    ]
    log_cmd(cmd)
    result = subprocess.run(cmd, capture_output=True, text=True)
    result.check_returncode()
    store_path = result.stdout.strip().rsplit(":", 1)[0]
    return "pkgs/" + store_path.split("/pkgs/", 1)[1]


def git(*args, dry_run: bool = False) -> None:
    cmd = [GIT_PATH] + list(args)
    log_cmd(cmd)
    if not dry_run:
        subprocess.run(cmd)


def log(message: str) -> None:
    print(message, file=sys.stderr)


def log_cmd(cmd: list[str]) -> None:
    log(f"+ {' '.join(cmd)}")


if __name__ == "__main__":
    main()
