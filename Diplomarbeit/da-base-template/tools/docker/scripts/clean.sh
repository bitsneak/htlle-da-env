#!/bin/bash
# Author: Marko Schrempf
set -euo pipefail

TARGETS="clean"
# Use cmd arg or the env TEMPLATE_NAME to change the templates folder name. Default: da-base-template
TEMPLATE_NAME="${1:-${TEMPLATE_NAME:-da-base-template}}"

export TARGETS
export TEMPLATE_NAME

/scripts/validator.sh
