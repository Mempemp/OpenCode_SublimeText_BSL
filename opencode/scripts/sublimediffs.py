"""Opens git-changed files in Sublime Text."""
import sys
import os
import subprocess
import json
import re

# Force UTF-8 everywhere — Windows PowerShell garbles cp1251
os.environ["PYTHONIOENCODING"] = "utf-8"
sys.stdout.reconfigure(encoding="utf-8", errors="replace")
sys.stderr.reconfigure(encoding="utf-8", errors="replace")

CONFIG_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "config.json")


def load_config():
    with open(CONFIG_PATH, encoding="utf-8") as f:
        return json.load(f)


def git_root():
    try:
        return subprocess.check_output(
            ["git", "rev-parse", "--show-toplevel"],
            text=True, encoding="utf-8", stderr=subprocess.DEVNULL
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
            text=True, encoding="utf-8", stderr=subprocess.DEVNULL
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

    # Normalize to Windows backslashes for subl.exe
    full_paths = [os.path.normpath(os.path.join(root, p)) for p in paths]
    subprocess.run([subl] + full_paths, shell=False)
    print(f"Opened {len(paths)} file(s) in Sublime")


if __name__ == "__main__":
    main()
