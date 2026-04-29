# Simple Containers for AI Tools on the MPI Cluster
## Installation
Start interactive job:
```bash
condor_submit_bid 25 -i -append request_cpus=8 -append request_memory=65536 -append request_gpus=1 -append "requirements=TARGET.CUDAGlobalMemoryMb>10000" -append +BypassLXCfs="true" -append "requirements=TARGET.CUDACapability>7" -append "request_disk=100G"
```
Inside this job install the container:
```
sh install.sh
```

Works in any POSIX shell (bash, zsh, fish, etc.).

After installation, the commands can be called in an interactive node.
A suitable node can be requested through
```
condor_submit_bid 25 -i -append request_cpus=8 -append request_memory=65536 -append +BypassLXCfs="true" -append "request_disk=3G"
```

## Usage
If you use the below commands, the agent will:
- have full write access to the current working directory (and agent configurations)
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
```

If you want your agent to additionally have access to `/fast` (read/write), use:
```bash
claude-contained-wfast
codex-contained-wfast
gemini-contained-wfast
```

If you want your agent to additionally submit HTCondor jobs from inside the container, use:
```bash
claude-contained-wfast-submit
codex-contained-wfast-submit
```

## Uninstall
```bash
sh uninstall.sh
```
This removes the scripts from `~/.local/bin/` and cleans up old bashrc aliases if present. The container image (~15GB) is not deleted automatically; the script prints its path for manual removal.
