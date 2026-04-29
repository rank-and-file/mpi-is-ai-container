#!/bin/bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"
mkdir -p build-logs
condor_submit_bid 25 build.sub
echo "Build logs: build-logs/build.{out,err,log}"
