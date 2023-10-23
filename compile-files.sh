#!/bin/bash

# Define the directory to search for .tex files
directory="tasks"

# Use 'find' to locate all .tex files in the specified directory and subdirectories
find "$directory" -type f -name "*.tex" -print0 | while IFS= read -r -d '' file; do
    # Get the directory containing the .tex file
    dir="$(dirname "$file")"

    # Change to the directory
    cd "$dir" || exit 1

    mkdir -p out
    echo "Compiling $file..."
    SECONDS=0
    # Compile the .tex file to PDF using 'pdflatex'
    pdflatex -interaction=batchmode -output-directory out "$(basename "$file")" > /dev/null 2>&1
    # Return to the original directory
    echo "Successfully compiled $file - took $SECONDS seconds"
    cd - || exit 1
done
