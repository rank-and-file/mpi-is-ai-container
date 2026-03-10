#!/bin/sh

set -eu

SCRIPTS="bash-contained bash-contained-wfast claude-contained claude-contained-wfast codex-contained codex-contained-wfast gemini-contained gemini-contained-wfast"
MARKER_START="# === ai-tools container aliases ==="
MARKER_END="# === end ai-tools container aliases ==="

# 1) Remove scripts from ~/.local/bin/
echo "Removing scripts from ~/.local/bin/..."
for script in $SCRIPTS; do
    if [ -f "$HOME/.local/bin/$script" ]; then
        rm "$HOME/.local/bin/$script"
        echo "  Removed $script"
    fi
done

# 2) Clean up old bashrc aliases if present
if [ -f "$HOME/.bashrc" ] && grep -qF "$MARKER_START" "$HOME/.bashrc"; then
    sed -i "/${MARKER_START}/,/${MARKER_END}/d" "$HOME/.bashrc"
    echo "Removed old bash aliases from ~/.bashrc"
fi

# 3) Print container paths for manual deletion
echo ""
echo "Done. Container images were NOT deleted. Remove them manually if desired:"
echo "  rm /fast/${USER}/containers/ai-tools.sif"
echo "  rm /fast/${USER}/containers/ai-tools.sif    (old name, if present)"
