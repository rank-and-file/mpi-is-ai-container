#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONTAINER="/fast/${USER}/containers/ai-tools.sif"
MARKER_START="# === ai-tools container aliases ==="
MARKER_END="# === end ai-tools container aliases ==="

# 1) Build the container
echo "Building container..."
bash "${SCRIPT_DIR}/build.sh"

# 2) Add shell functions to .bashrc
#    --writable-tmpfs: allow ephemeral writes inside the container
#    --bind "$PWD": only the current directory is persistent
#    --nv: NVIDIA GPU passthrough
#    Config dirs (~/.claude, ~/.codex, ~/.gemini) are bound if they exist so
#    that settings/API keys stored on disk are available inside the container.

MARKER_START="# === ai-tools container aliases ==="
MARKER_END="# === end ai-tools container aliases ==="

BLOCK=$(cat <<'EOF'
# === ai-tools container aliases ===
bash-contained() {
    local -a binds=(--bind "$PWD")
    [[ -d "$HOME/.claude" ]] && binds+=(--bind "$HOME/.claude")
    [[ -f "$HOME/.claude.json" ]] && binds+=(--bind "$HOME/.claude.json")
    apptainer exec --nv --writable-tmpfs --contain "${binds[@]}" --pwd "$PWD" \
        "/fast/${USER}/containers/ai-tools.sif" bash --login -i "$@"
}

claude-contained() {
    local -a binds=(--bind "$PWD")
    [[ -d "$HOME/.claude" ]] && binds+=(--bind "$HOME/.claude")
    [[ -f "$HOME/.claude.json" ]] && binds+=(--bind "$HOME/.claude.json")
    apptainer exec --nv --writable-tmpfs --contain "${binds[@]}" --pwd "$PWD" \
        "/fast/${USER}/containers/ai-tools.sif" claude --dangerously-skip-permissions "$@"
}

codex-contained() {
    local -a binds=(--bind "$PWD")
    [[ -d "$HOME/.codex" ]] && binds+=(--bind "$HOME/.codex")
    apptainer exec --nv --writable-tmpfs --contain "${binds[@]}" --pwd "$PWD" \
        "/fast/${USER}/containers/ai-tools.sif" codex --yolo "$@"
}

gemini-contained() {
    local -a binds=(--bind "$PWD")
    [[ -d "$HOME/.gemini" ]] && binds+=(--bind "$HOME/.gemini")
    apptainer exec --nv --writable-tmpfs --contain "${binds[@]}" --pwd "$PWD" \
        "/fast/${USER}/containers/ai-tools.sif" gemini --yolo "$@"
}
# === end ai-tools container aliases ===
EOF
)

# Remove old block if present
if grep -qF "$MARKER_START" "$HOME/.bashrc"; then
    sed -i "/${MARKER_START//\//\\/}/,/${MARKER_END//\//\\/}/d" "$HOME/.bashrc"
    echo "Replaced existing aliases in ~/.bashrc"
else
    echo "Added aliases to ~/.bashrc"
fi

printf '\n%s\n' "$BLOCK" >> "$HOME/.bashrc"

echo "Run 'source ~/.bashrc' to activate: claude-contained, codex-contained, gemini-contained"
