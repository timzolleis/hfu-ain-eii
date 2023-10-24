#!/bin/bash

directory="/tasks"
outDirectory="/documentation"

find "$directory" -type f -name "*.tex" -print0 | xargs -0 -I {} echo "Found files: {}"

find "$directory" -type f -name "*.tex" -print0 | while IFS= read -r -d '' file; do
    dir="$(dirname "$file")"

    cd "$dir" || exit 1
       echo "Changing context to $dir"
    echo "Compiling $file..."
    SECONDS=0
    mkdir -p out
    # This command runs two times to ensure references are correct
    pdflatex -interaction=batchmode -output-directory out "$(basename "$file")" > /dev/null
    pdflatex -interaction=batchmode -output-directory out "$(basename "$file")" > /dev/null
    echo "Successfully compiled $file - took $SECONDS seconds"
    echo "Copying files..."
    start_time=$(date +%s%N)
    parentDir="$(basename "$(dirname "$dir")")"
    newFileName="$parentDir"_"$(basename "$dir")"
    mv out/"$(basename "$file" .tex)".pdf "$outDirectory/$newFileName".pdf
    end_time=$(date +%s%N)
    elapsed_time=$(( (end_time - start_time) / 1000000 ))
    echo "Successfully copied file to $outDirectory/$newFileName.pdf - took ${elapsed_time} ms"
    cd - || exit 1
done
