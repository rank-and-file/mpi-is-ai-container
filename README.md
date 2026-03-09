# Simple Containers for AI Tools on the MPI Cluster
## Installation
Start interactive job:
```bash
condor_submit_bid 25 -i -append request_cpus=8 -append request_memory=65536 -append request_gpus=1 -append "requirements=TARGET.CUDAGlobalMemoryMb>20000" -append +BypassLXCfs="true" -append "requirements=TARGET.CUDACapability>7" -append "request_disk=200G"
```
Inside this job install the container:
```
bash install.sh
```

It works only on the default shell (bash), not zsh.

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
```
