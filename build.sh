#!/bin/bash

container_dir="/fast/${USER}/containers/"
mkdir -p "${container_dir}"
apptainer build "${container_dir}/ai-tools.sif" "container.def"

