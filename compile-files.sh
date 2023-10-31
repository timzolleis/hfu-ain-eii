#!/bin/bash

directory="/tasks"
if [ -n "$1" ]; then
  directory="$1"
fi

outDirectory="/documentation"
if [ -n "$2" ]; then
  outDirectory="$2"
fi
find "$directory" -type f -name "*.tex" -print0 | xargs -0 -I {} echo "Found files: {}"

find "$directory" -type f -name "*.tex" -print0 | while IFS= read -r -d '' file; do
    dir="$(dirname "$file")"

    cd "$dir" || exit 1
       echo "Changing context to $dir"
    echo "Compiling $file..."
    mkdir -p out
    compile_start_time=$(date +%s%N)
    # This command runs two times to ensure references are correct
    pdflatex -interaction=batchmode -output-directory out "$(basename "$file")"
    pdflatex -interaction=batchmode -output-directory out "$(basename "$file")"
    compile_end_time=$(date +%s%N)
    compile_total_time=$(( (compile_end_time - compile_start_time) / 1000000 ))
    # Check if the file is present and if it is move it
    if [ -f out/"$(basename "$file" .tex)".pdf ]; then
      echo "Successfully compiled $file in ${compile_total_time} ms"
      echo "Moving file..."
      parentDir="$(basename "$(dirname "$dir")")"
      newFileName="$parentDir"_"$(basename "$dir")"
      mv out/"$(basename "$file" .tex)".pdf "$outDirectory/$newFileName".pdf
      echo "Successfully copied file to $outDirectory/$newFileName.pdf "
      cd - || exit 1
    else
      echo "Failed to compile $file"
      echo "Logging logs..."
      cat out/"$(basename "$file" .tex)".log
      exit 1
    fi
done
