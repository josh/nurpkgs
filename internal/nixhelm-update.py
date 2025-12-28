import os
import re
import subprocess
import sys

import click
import requests
import yaml

GIT_PATH = "@git@"
NIX_PATH = "@nix@"
NIX_PREFIX_URL_PATH = "@nix-prefetch-url@"


@click.command()
@click.option("--url", required=True)
@click.option("--chart", required=True)
@click.option("--nix-name", envvar="UPDATE_NIX_NAME")
@click.option("--nix-pname", envvar="UPDATE_NIX_PNAME")
@click.option("--nix-old-version", envvar="UPDATE_NIX_OLD_VERSION")
@click.option("--nix-attr-path", envvar="UPDATE_NIX_ATTR_PATH")
@click.option("--dry-run", is_flag=True)
def main(
    url: str,
    chart: str,
    nix_name: str | None,
    nix_pname: str | None,
    nix_old_version: str | None,
    nix_attr_path: str | None,
    dry_run: bool,
):
    filename = None

    if nix_attr_path and not filename:
        filename = nix_attr_filename(attr_path=nix_attr_path)

    assert filename, "Filename is required"

    with open(filename, "r") as f:
        content = f.read()

    if not nix_pname:
        nix_pname = os.path.basename(filename).removesuffix(".nix")

    helm_index_resp = requests.get(f"{url}/index.yaml")
    helm_index_resp.raise_for_status()
    helm_index = yaml.safe_load(helm_index_resp.content)
    assert chart in helm_index["entries"], f"Chart {chart} not found in Helm index"

    helm_release = helm_index["entries"][chart][0]

    new_description = helm_release.get("description")
    new_version = helm_release["version"]

    new_url = helm_release["urls"][0]
    if not new_url.startswith("http"):
        new_url = f"{url}/{new_url}"

    new_sha256 = None
    if new_url:
        uses_fetchzip = "fetchzip {" in content
        new_sha256 = nix_prefetch_url(url=new_url, unpack=uses_fetchzip)

    if new_version:
        content = re.sub(
            r'(^\s+version = ")(.+)(")',
            lambda m: m.group(1) + new_version + m.group(3),
            content,
            flags=re.MULTILINE,
        )

    if new_description:
        content = re.sub(
            r'(^\s+description = ")(.+)(")',
            lambda m: m.group(1) + new_description + m.group(3),
            content,
            flags=re.MULTILINE,
        )

    if new_url:
        content = re.sub(
            r'(^\s+url = ")(.+)(")',
            lambda m: m.group(1) + new_url + m.group(3),
            content,
            flags=re.MULTILINE,
        )

    if new_sha256:
        content = re.sub(
            r'(^\s+sha256 = ")(.+)(")',
            lambda m: m.group(1) + new_sha256 + m.group(3),
            content,
            flags=re.MULTILINE,
        )

    if nix_old_version:
        commit_message = f"{nix_pname}: {nix_old_version} -> {new_version}"
    else:
        commit_message = f"{nix_pname}: {new_version}"

    if dry_run:
        log(f"cat >{filename} <<EOF")
        log(content)
        log("EOF")
    else:
        with open(filename, "w") as f:
            f.write(content)

    git("add", filename, dry_run=dry_run)
    git("commit", "--message", commit_message, dry_run=dry_run)


def nix_prefetch_url(url: str, unpack: bool = False) -> str:
    cmd = [NIX_PREFIX_URL_PATH, "--type", "sha256"]
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
