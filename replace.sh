#!/bin/bash

# Define arguments with default values
INPUT="."
EXT="*"
FROM=""
TO=""
HIDDEN=0

# Read command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -i|--input) INPUT="$2"; shift ;;
        -e|--ext) EXT="$2"; shift ;;
        -f|--from) FROM="$2"; shift ;;
        -t|--to) TO="$2"; shift ;;
        -h|--hidden) HIDDEN=1 ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Check if from and to values are provided
if [[ -z "$FROM" || -z "$TO" ]]; then
    echo "Please specify the 'from' and 'to' values."
    exit 1
fi

# Function to replace content in files
replace_content() {
    local file="$1"
    local from="$2"
    local to="$3"
    
    sed -i -E "s/${from}/${to}/g" "$file"
}

# Determine if the input is a directory or a file
if [[ -d "$INPUT" ]]; then
    # Use find command to get files based on extension and hidden options
    if [[ "$EXT" == "*" ]]; then
        if [[ $HIDDEN -eq 1 ]]; then
            find "$INPUT" -type f | while read -r file; do
                replace_content "$file" "$FROM" "$TO"
            done
        else
            find "$INPUT" ! -path '*/\.*' -type f | while read -r file; do
                replace_content "$file" "$FROM" "$TO"
            done
        fi
    else
        if [[ $HIDDEN -eq 1 ]]; then
            find "$INPUT" -type f -name "*.${EXT}" | while read -r file; do
                replace_content "$file" "$FROM" "$TO"
            done
        else
            find "$INPUT" ! -path '*/\.*' -type f -name "*.${EXT}" | while read -r file; do
                replace_content "$file" "$FROM" "$TO"
            done
        fi
    fi
elif [[ -f "$INPUT" ]]; then
    replace_content "$INPUT" "$FROM" "$TO"
else
    echo "Invalid input path provided."
    exit 1
fi

