"""Opens git-changed files in Sublime Text."""
import sys
import os
import subprocess
import json
import re

CONFIG_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "config.json")


def load_config():
    with open(CONFIG_PATH) as f:
        return json.load(f)


def git_root():
    try:
        return subprocess.check_output(
            ["git", "rev-parse", "--show-toplevel"],
            text=True, stderr=subprocess.DEVNULL
        ).strip()
    except Exception:
        return os.getcwd()


def main():
    mask = sys.argv[1] if len(sys.argv) > 1 else ""

    cfg = load_config()
    subl = cfg["sublime_exe"]
    root = git_root()

    try:
        files = subprocess.check_output(
            ["git", "-c", "core.quotePath=false", "diff", "HEAD",
             "--name-only", "--diff-filter=ACMRT"],
            text=True, stderr=subprocess.DEVNULL
        ).strip()
    except Exception:
        print("Not a git repository")
        sys.exit(1)

    if not files:
        print("No changed files")
        sys.exit(0)

    paths = [f for f in files.split("\n") if f]

    if mask:
        pat = "^" + re.escape(mask).replace("\\*", ".*") + "$"
        paths = [f for f in paths if re.match(pat, f)]
        if not paths:
            print(f"No files matching '{mask}'")
            sys.exit(0)

    full_paths = [os.path.join(root, p) for p in paths]
    subprocess.run([subl] + full_paths, shell=False)
    print(f"Opened {len(paths)} file(s) in Sublime")


if __name__ == "__main__":
    main()
