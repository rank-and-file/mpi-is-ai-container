#!/bin/sh

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPTS="bash-contained bash-contained-wfast claude-contained claude-contained-wfast codex-contained codex-contained-wfast gemini-contained gemini-contained-wfast"
MARKER_START="# === ai-tools container aliases ==="
MARKER_END="# === end ai-tools container aliases ==="

# 1) Build the container
echo "Building container..."
sh "$SCRIPT_DIR/build.sh"

# 2) Remove old bashrc aliases if present (migration from v1)
if [ -f "$HOME/.bashrc" ] && grep -qF "$MARKER_START" "$HOME/.bashrc"; then
    sed -i "/${MARKER_START}/,/${MARKER_END}/d" "$HOME/.bashrc"
    echo "Removed old bash aliases from ~/.bashrc"
fi

# 3) Install scripts to ~/.local/bin/
mkdir -p "$HOME/.local/bin"
for script in $SCRIPTS; do
    cp "$SCRIPT_DIR/bin/$script" "$HOME/.local/bin/$script"
    chmod +x "$HOME/.local/bin/$script"
done
echo "Installed scripts to ~/.local/bin/"

# 4) Ensure ~/.local/bin is on PATH
case ":${PATH}:" in
    *:$HOME/.local/bin:*) ;;
    *)
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.profile"
        echo "Added ~/.local/bin to PATH in ~/.profile (log out and back in, or run: export PATH=\"\$HOME/.local/bin:\$PATH\")"
        ;;
esac

# 5) Summary
echo ""
echo "Installed: $SCRIPTS"
echo "Container: /fast/${USER}/containers/ai-tools.sif"
