#!/bin/bash
# Author: Marko Schrempf
set -euo pipefail

# Use env TARGETS to determine one or multiple make targets. Default: pdf
TARGETS="${TARGETS:-pdf}"
# Use env TEMPLATE to change the template folder name. Default: da-base-template
TEMPLATE="${TEMPLATE:-da-base-template}"
# Use env SOURCE_DIR to change the source folder name. Default: /workspace
SOURCE_DIR="${SOURCE_DIR:-/workspace}"
# Use cmd arg or the env OUTPUT_DIR to change the output folder name. Default: Default: SOURCE_DIR/out
OUTPUT_DIR="${OUTPUT_DIR:-$SOURCE_DIR/out}"

export TARGETS
export TEMPLATE
export SOURCE_DIR
export OUTPUT_DIR

if [ "$#" -gt 0 ]; then
    /scripts/command_wrapper.sh "$@"
else
    /scripts/validator.sh
fi
