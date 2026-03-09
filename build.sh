#!/bin/bash

container_dir="/fast/${USER}/containers/"

apptainer build "${container_dir}/ai-tools.sif" "container.def"

