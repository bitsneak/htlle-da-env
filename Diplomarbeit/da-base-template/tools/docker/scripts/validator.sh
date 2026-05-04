#!/bin/bash
# Author: Marko Schrempf
set -euo pipefail

# Priority: cli args > env vars > defaults
# Determine one or multiple make targets
TARGETS_VALUE="${TARGETS:-pdf}"
# Determine template name
TEMPLATE_VALUE="${TEMPLATE:-da-base-template}"
CLI_TARGET_SEEN=0
CLI_TEMPLATE_SEEN=0

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
            else
                echo "Unknown argument: $arg"
                echo "Usage: validator.sh [pdf|spellcheck|tex|clean|target1,target2] [template-name]"
                echo "   or: validator.sh [--targets=pdf,spellcheck] [--template=template-name]"
                exit 1
            fi
            ;;
    esac
done

TARGETS="$TARGETS_VALUE"
TEMPLATE="$TEMPLATE_VALUE"
# Use the env SOURCE_DIR to change the directory in the container where the files to build lie
# Same as mounted directory and workdir in Dockerfile
SOURCE_DIR="/workspace"
# Possible make targets
ALLOWED_TARGETS=("pdf" "spellcheck" "tex" "clean")

# Check if /workspace has the necessary files and folders
if [ -z "$(ls -A "doc" 2>/dev/null)" ] || [ -z "$(ls -A "img" 2>/dev/null)" ] || [ -z "$(ls -A "pdfs" 2>/dev/null)" ] || [ ! -f "literatur.bib" ] || [ ! -f "metadata.yaml" ]; then
    echo "Necessary diploma thesis files/folders are missing/incomplete"
    echo "Please ensure the diploma thesis is correctly set up"
    exit 1
fi

# Check if the template directory exists and has all the necessary files
if [ ! -d "$TEMPLATE" ] || [ ! -f "$TEMPLATE/Makefile" ] || [ -z "$(ls -A "$TEMPLATE/style" 2>/dev/null)" ]; then
    echo "Template is missing/incomplete"
    echo "Please ensure the template is correctly set up"
    exit 1
fi

# Check all chosen targets and execute them one by one
IFS=',' read -r -a REQUESTED_TARGETS <<< "$TARGETS"

if [ "${#REQUESTED_TARGETS[@]}" -eq 0 ]; then
    echo "No targets provided"
    echo "Allowed targets: ${ALLOWED_TARGETS[*]}"
    exit 1
fi

for raw_target in "${REQUESTED_TARGETS[@]}"; do
    target="$(echo "$raw_target" | xargs)"

    if [ -z "$target" ]; then
        echo "Invalid empty target in TARGETS: $TARGETS"
        echo "Allowed targets: ${ALLOWED_TARGETS[*]}"
        exit 1
    fi

    if [[ ! " ${ALLOWED_TARGETS[*]} " =~ " ${target} " ]]; then
        echo "Invalid target: $target"
        echo "Allowed targets: ${ALLOWED_TARGETS[*]}"
        exit 1
    fi
done

# Execute targets only after all of them are validated
for raw_target in "${REQUESTED_TARGETS[@]}"; do
    target="$(echo "$raw_target" | xargs)"
    make -C "$TEMPLATE" "$target" SOURCEDIR="$SOURCE_DIR"
done
