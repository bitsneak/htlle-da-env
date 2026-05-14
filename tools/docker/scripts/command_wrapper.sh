#!/bin/bash
# Author: Marko Schrempf
set -euo pipefail

TARGETS_VALUE="${TARGETS:-pdf}"
TEMPLATE_VALUE="${TEMPLATE:-da-base-template}"
SOURCE_DIR_VALUE="${SOURCE_DIR:-/workspace}"
OUTPUT_DIR_VALUE="${OUTPUT_DIR:-/TODO}"
CLI_TARGET_SEEN=0
CLI_TEMPLATE_SEEN=0
CLI_SOURCE_DIR_SEEN=0
CLI_OUTPUT_DIR_SEEN=0

for arg in "$@"; do
    case "$arg" in
        --targets=*)
            TARGETS_VALUE="${arg#--targets=}"
            CLI_TARGET_SEEN=1
            ;;
        --template=*)
            TEMPLATE_VALUE="${arg#--template=}"
            CLI_TEMPLATE_SEEN=1
            ;;
        --source-dir=*)
            SOURCE_DIR_VALUE="${arg#--source-dir=}"
            CLI_SOURCE_DIR_SEEN=1
            ;;
        --output-dir=*)
            OUTPUT_DIR_VALUE="${arg#--output-dir=}"
            CLI_OUTPUT_DIR_SEEN=1
            ;;
        pdf|spellcheck|tex|clean)
            TARGETS_VALUE="$arg"
            CLI_TARGET_SEEN=1
            ;;
        "")
            ;;
        *)
            if [ "$CLI_TARGET_SEEN" -eq 0 ]; then
                TARGETS_VALUE="$arg"
                CLI_TARGET_SEEN=1
            elif [ "$CLI_TEMPLATE_SEEN" -eq 0 ]; then
                TEMPLATE_VALUE="$arg"
                CLI_TEMPLATE_SEEN=1
            elif [ "$CLI_SOURCE_DIR_SEEN" -eq 0 ]; then
                SOURCE_DIR_VALUE="$arg"
                CLI_SOURCE_DIR_SEEN=1
            elif [ "$CLI_OUTPUT_DIR_SEEN" -eq 0 ]; then
                SOURCE_DIR_VALUE="$arg"
                CLI_OUTPUT_DIR_SEEN=1
            else
                echo "Unknown argument: $arg"
                echo "Usage: build [pdf|spellcheck|tex|clean] [template-name] [source-dir] [output-dir]"
                echo "   or: build [--targets=pdf,spellcheck,tex,clean] [--template=template-name] [--source-dir=source-directory] [--output-dir=output-directory]"
                exit 1
            fi
            ;;
    esac
done

export TARGETS="$TARGETS_VALUE"
export TEMPLATE="$TEMPLATE_VALUE"
export SOURCE_DIR="$SOURCE_DIR_VALUE"
export OUTPUT_DIR="$OUTPUT_DIR_VALUE"

/scripts/validator.sh
