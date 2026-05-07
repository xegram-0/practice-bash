#!/bin/bash

for i in */; do
    i="${i%/}"

    echo "Creating $i.cbz..."

    zip -q -r "$i.cbz" "$i"
done

echo "Done!"
