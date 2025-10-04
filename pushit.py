import subprocess
import sys
import os

def run_cmd(cmd):
    """Run a command and stream output live."""
    process = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    for line in process.stdout:
        print(line, end="")
    process.wait()
    return process.returncode

def main():
    # === SETTINGS ===
    repo_dir = os.getcwd()   # assumes you run from repo root
    branch = "main"          # change if your branch is different (e.g. "master")
    remote = "origin"
    message = "Auto commit from pushit.py"

    # allow passing commit message: python pushit.py "your message"
    if len(sys.argv) > 1:
        message = " ".join(sys.argv[1:])

    print(f"\n📂 Repo: {repo_dir}")
    print(f"🌿 Branch: {branch}")
    print(f"📝 Commit: {message}\n")

    cmds = [
        "git add .",
        f'git commit -m "{message}"',
        f"git pull {remote} {branch} --rebase",
        f"git push {remote} {branch}"
    ]

    for cmd in cmds:
        print(f"\n➡️ {cmd}")
        code = run_cmd(cmd)
        if code != 0:
            print(f"\n❌ Command failed: {cmd}")
            print("💡 If you hit rebase conflicts, fix them and run again, or force push manually.")
            sys.exit(code)

    print("\n✅ Push complete!")

if __name__ == "__main__":
    main()
