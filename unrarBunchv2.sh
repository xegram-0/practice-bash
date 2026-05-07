
#!/bin/bash

# List of passwords to try (order matters)
passwords=(
    "mrcong.com"
    "mitaku.net"
    "misskon.com"

)

shopt -s nullglob

for rarfile in *.rar *.part1.rar; do
    # Skip non-first volumes like part2, part3, r00, etc.
    if [[ "$rarfile" =~ \.part[2-9][0-9]*\.rar$ ]]; then
        continue
    fi

    echo "Processing archive: $rarfile"
    extracted=false

    for password in "${passwords[@]}"; do
        echo "  Trying password..."
        unrar x -o- -p"$password" "$rarfile" >/dev/null 2>&1

        if [ $? -eq 0 ]; then
            echo "  ✔ Extracted successfully"
            extracted=true
            break
        fi
    done

    if [ "$extracted" = false ]; then
        echo "  ✖ All passwords failed for $rarfile"
    fi
done
