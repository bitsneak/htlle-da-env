#!/bin/bash
# Author: Marko Schrempf
set -euo pipefail

TARGETS="pdf"
# Use cmd arg or the env TEMPLATE to change the templates folder name. Default: da-base-template
TEMPLATE="${1:-${TEMPLATE:-da-base-template}}"
# Use cmd arg or the env SOURCE_DIR to change the source folder name. Default: /workspace
SOURCE_DIR="${2:-${SOURCE_DIR:-/workspace}}"
# Use cmd arg or the env OUTPUT_DIR to change the output folder name. Default: Default: SOURCE_DIR/out
OUTPUT_DIR="${3:-${OUTPUT_DIR:-$SOURCE_DIR/out}}"

export TARGETS
export TEMPLATE
export SOURCE_DIR
export OUTPUT_DIR

/scripts/validator.sh
