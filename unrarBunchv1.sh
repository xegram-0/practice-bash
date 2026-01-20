#!/bin/bash

password="misskon.com"  # Initial/default password

for rarfile in *.rar; do
    echo "Extracting $rarfile with default password..."

    # Try extracting with default password
    unrar x -p"$password" "$rarfile"

    # Check if extraction failed (non-zero exit status)
    if [ $? -ne 0 ]; then
        echo "Default password failed for $rarfile."

        # Prompt user for new password
        read -sp "Enter new password for $rarfile: " password
        echo

        # Try again with user-provided password
        unrar x -p"$password" "$rarfile"

        # Optional: Check again if it failed and alert the user
        if [ $? -ne 0 ]; then
            echo "Failed again: Incorrect password for $rarfile."
        else
            echo "Successfully extracted $rarfile with new password."
        fi
    else
        echo "Successfully extracted $rarfile with default password."
    fi
done

