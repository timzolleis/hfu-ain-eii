echo "Listing all files bigger than 500kb in the current directory..."
result=$(find . -maxdepth 1 -type f -size +500k)
if [ -n "$result" ]; then
    echo "$result"
else
    echo "No files found"
fi
