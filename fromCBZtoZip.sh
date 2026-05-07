#!/bin/bash

# Loop through all .cbz files in the current directory
for cbz in *.cbz; do
    # Skip if no .cbz files exist
    [ -e "$cbz" ] || continue

    # Get filename without extension
    name="${cbz%.cbz}"

    # Rename .cbz to .zip
    zipfile="$name.zip"
    cp "$cbz" "$zipfile"

    # Create destination folder
    mkdir -p "$name"

    # Extract zip into its folder
    unzip -q "$zipfile" -d "$name"

    echo "Extracted: $cbz → $name/"
done
