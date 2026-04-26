#!/bin/bash
# Author: Marko Schrempf
set -euo pipefail

# Use env TARGETS (or deprecated TARGET) to determine one or multiple make targets. Defaults to pdf
TARGETS="${TARGETS:-${TARGET:-pdf}}"
# Use env TEMPLATE_NAME to change the template folder name
TEMPLATE_NAME="${TEMPLATE_NAME:-da-base-template}"

export TARGETS
export TEMPLATE_NAME

if [ "$#" -gt 0 ]; then
    /scripts/command_wrapper.sh "$@"
else
    /scripts/validator.sh
fi
