#!/bin/bash

# Directory containing the zip archives
input_dir="path/to/your/zip/files"

# Directory for temporary extraction
temp_dir="/tmp/unzip_process"

# Loop over each zip file in the input directory
for zip_file in "$input_dir"/*.zip; do
    # Create a temporary folder for extraction
    mkdir -p "$temp_dir"
    
    # Unzip the file into the temporary directory
    unzip -q "$zip_file" -d "$temp_dir"
    
    # Find the last modified file in the extracted directory and delete it
    last_file=$(find "$temp_dir" -type f | sort | tail -n 1)
    rm -f "$last_file"
    
    # Zip the modified contents back into a new archive with a .cbz extension
    new_file="${zip_file%.zip}.cbz"
    (cd "$temp_dir" && zip -r -q "$new_file" .)
    
    # Move the new .cbz file to the original directory
    mv "$new_file" "$input_dir"
    
    # Clean up the temporary directory
    rm -rf "$temp_dir"
done

echo "Processing complete!"