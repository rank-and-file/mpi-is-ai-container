# Simple Containers for AI Tools on the MPI Cluster
## Installation
Start interactive job:
```bash
condor_submit_bid 25 -i -append request_cpus=8 -append request_memory=65536 -append request_gpus=1 -append "requirements=TARGET.CUDAGlobalMemoryMb>20000" -append +BypassLXCfs="true" -append "requirements=TARGET.CUDACapability>7" -append "request_disk=200G"
```
Inside this job install the container:
```
sh install.sh
```

Works in any POSIX shell (bash, zsh, fish, etc.).

After installation, the commands can be called anywhere (also on the login node, etc.)

## Usage
If you use the below commands, the agent will:
- have full write access to the current working directory
- have no access to the other directories
- automatically accept all edits and call all commands (no approvals needed, uses `--yolo / --dangerously-skip-permissions`).

Only use it if you are sure about this :)

```bash
# As a drop in replacement of claude
claude-contained

# As a drop in replacement of codex
codex-contained

# As a drop in replacement of gemini
gemini-contained

# Interactive bash shell inside the container
bash-contained

# -wfast variants: same as above but with /fast/$USER mounted (read/write)
claude-contained-wfast
codex-contained-wfast
gemini-contained-wfast
bash-contained-wfast
```

## Uninstall
```bash
sh uninstall.sh
```
This removes the scripts from `~/.local/bin/` and cleans up old bashrc aliases if present. The container image (~15GB) is not deleted automatically; the script prints its path for manual removal.
