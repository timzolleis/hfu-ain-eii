#!/bin/bash

directory="/tasks"

find "$directory" -type f -name "*.tex" -print0 | while IFS= read -r -d '' file; do
    dir="$(dirname "$file")"

    cd "$dir" || exit 1

    mkdir -p out
    echo "Compiling $file..."
    SECONDS=0
    # This command runs two times to ensure references are correct
    pdflatex -interaction=batchmode -output-directory out "$(basename "$file")"
    pdflatex -interaction=batchmode -output-directory out "$(basename "$file")"
    echo "Successfully compiled $file - took $SECONDS seconds"
    cd - || exit 1
done
