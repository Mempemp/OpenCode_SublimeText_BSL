"""Opens files in Sublime Text. Exact, partial, or fuzzy paths."""
import sys
import os
import subprocess
import glob as globmod
import json

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


def git_ls_files(pattern):
    """Search tracked files via git ls-files."""
    try:
        out = subprocess.check_output(
            ["git", "-c", "core.quotePath=false", "ls-files", f"*{pattern}*"],
            text=True, encoding="utf-8", stderr=subprocess.DEVNULL
        ).strip()
        return [f for f in out.split("\n") if f]
    except Exception:
        return []


def find_fuzzy(root, name):
    """Find file in project: exact -> git ls-files -> filesystem -> fuzzy."""
    # 1. Exact path
    exact = os.path.join(root, name)
    if os.path.isfile(exact):
        return exact

    # 2. git ls-files (fast, all tracked files)
    candidates = git_ls_files(name)
    if candidates:
        # Pick shortest matching path
        candidates.sort(key=len)
        return os.path.join(root, candidates[0])

    # 3. Filesystem: try common extensions
    parts = name.lower().replace("\\", "/").split("/")
    basename = parts[-1]
    if not os.path.splitext(basename)[1]:
        # No extension — try .bsl and .xml
        for ext in (".bsl", ".xml"):
            full = os.path.join(root, name + ext)
            if os.path.isfile(full):
                return full

    # 4. Fuzzy: search by basename with os.walk
    matches = []
    for dirpath, _, filenames in os.walk(root):
        for fn in filenames:
            if basename.lower() in fn.lower():
                matches.append(os.path.join(dirpath, fn))
            if len(matches) >= 20:
                break
        if len(matches) >= 20:
            break

    if matches:
        matches.sort(key=len)  # shortest path first
        return matches[0]

    # 5. Nothing found
    return exact


def main():
    if len(sys.argv) < 2:
        print("Usage: sublime-open.py <file> [file ...]")
        sys.exit(1)

    cfg = load_config()
    subl = cfg["sublime_exe"]
    root = git_root()
    names = sys.argv[1:]

    resolved = []
    for name in names:
        path = find_fuzzy(root, name)
        resolved.append(path)
        if path and os.path.isfile(path):
            print(f"  {name} -> found")
        else:
            print(f"  {name} -> NOT FOUND (opening as new)")

    subprocess.run([subl] + [os.path.normpath(p) for p in resolved], shell=False)
    print(f"Opened {len(names)} file(s) in Sublime")


if __name__ == "__main__":
    main()
