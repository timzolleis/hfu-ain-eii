#!/bin/bash

workdir="/workdir"
if [ -n "$1" ]; then
  workdir="$1"
fi


echo "Creating output directory"
mkdir -p "$workdir/dist"


cd "$workdir" || exit 1

latestTag=$(git describe --tags --abbrev=0)
changedFiles=$(git diff --no-commit-id --name-only -r  "$latestTag..HEAD" | grep '\.tex$')


if [ -z "$changedFiles" ]; then
  echo "Nothing to compile..."
  exit 0
fi

echo "Changed files $changedFiles"

# Find and compile only modified .tex files
 for file in $changedFiles; do
  dir="$(dirname "$file")"
  echo "Changing context to $dir"
  cd "$dir" || exit 1
  fileName="$(basename "$file")"

  echo "Compiling $fileName..."
  mkdir -p out
  compile_start_time=$(date +%s%N)
  # This command runs two times to ensure references are correct
  pdflatex -interaction=batchmode -output-directory out "$fileName"
  pdflatex -interaction=batchmode -output-directory out "$fileName"
  compile_end_time=$(date +%s%N)
  compile_total_time=$(( (compile_end_time - compile_start_time) / 1000000 ))
  # Check if the file is present and if it is, move it
  if [ -f out/"$(basename "$fileName" .tex)".pdf ]; then
    echo "Successfully compiled $fileName in ${compile_total_time} ms"
    echo "Contents of out directory:"
    ls -la out
    echo "Moving file..."
    parentDir="$(basename "$(dirname "$dir")")"
    newFileName="$parentDir"_"$(basename "$dir")"
    mv out/"$(basename "$fileName" .tex)".pdf "$workdir/dist/$newFileName".pdf
    echo "Successfully copied file to $workdir/dist/$newFileName.pdf "
  else
    echo "Failed to compile $fileName"
    echo "Logging logs..."
    cat out/"$(basename "$fileName" .tex)".log
    exit 1
  fi
  cd - || exit 1
done
