#!/bin/bash

for i in */; do
    i="${i%/}"

    echo "Creating $i.cbz..."

    if zip -q -r "$i.cbz" "$i"; then
        echo "Testing $i.cbz..."

        if zip -T "$i.cbz" > /dev/null 2>&1; then
            echo "Archive OK. Moving $i to trash..."
            gio trash "$i"   # change to 'trash' on macOS if needed
        else
            echo "ERROR: $i.cbz is corrupted! Keeping original folder."
        fi
    else
        echo "ERROR: Failed to create $i.cbz"
    fi

    echo "-----------------------------"
done

echo "Done!"
