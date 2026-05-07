
#!/usr/bin/env bash

# -----------------------
# Passwords to try
# -----------------------
passwords=(
    "misskon.com"
    "mitaku.net"
    "mrcong.com"
)

shopt -s nullglob

DRY_RUN=false

# Counters and trackers
success_count=0
fail_count=0
failed_archives=()

# -----------------------
# Argument parsing
# -----------------------
while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# -----------------------
# Record initial contents
# -----------------------
mapfile -t initial_items < <(find . -mindepth 1)
declare -A initial_map
for f in "${initial_items[@]}"; do
    initial_map["$f"]=1
done

# -----------------------
# Process one archive
# -----------------------
process_archive() {
    local rarfile="$1"
    local extracted=false

    if $DRY_RUN; then
        ((success_count++))
        echo "Processing successfully '$rarfile' (dry-run)"
        return
    fi

    for password in "${passwords[@]}"; do
        if unrar x -o- -p"$password" "$rarfile" >/dev/null 2>&1; then
            extracted=true
            ((success_count++))
            echo "Processing successfully '$rarfile' using '$password'"
            break
        fi
    done

    if ! $extracted; then
        ((fail_count++))
        failed_archives+=("$rarfile")
        echo "Failed to extract '$rarfile'"
    fi
}

# -----------------------
# Collect archives
# -----------------------
archives=()
for f in *.rar *.part1.rar; do
    [[ "$f" =~ \.part[2-9][0-9]*\.rar$ ]] && continue
    archives+=("$f")
done

if (( ${#archives[@]} == 0 )); then
    echo "No RAR archives found."
    exit 0
fi

# -----------------------
# Run extraction
# -----------------------
for rarfile in "${archives[@]}"; do
    process_archive "$rarfile"
done

# -----------------------
# Count only new folders/files created by extraction (recursive)
# -----------------------
folder_count=0
declare -A filetypes

while IFS= read -r f; do
    [[ -n "${initial_map["$f"]}" ]] && continue  # skip pre-existing
    if [[ -d "$f" ]]; then
        ((folder_count++))
    elif [[ -f "$f" ]]; then
        ext="${f##*.}"
        [[ -z "$ext" ]] && ext="no_extension"
        ext="${ext,,}"
        ((filetypes["$ext"]++))
    fi
done < <(find . -mindepth 1)

# -----------------------
# Print summary
# -----------------------
echo
echo "================ SUMMARY ================"
echo "Total archives processed : ${#archives[@]}"
echo "Successfully extracted   : $success_count"
echo "Failed to extract       : $fail_count"

if ((fail_count > 0)); then
    echo "Failed archives:"
    for a in "${failed_archives[@]}"; do
        echo "  $a"
    done
fi

echo "New folders extracted    : $folder_count"
echo "New file type counts:"
for ext in "${!filetypes[@]}"; do
    echo "  $ext : ${filetypes[$ext]}"
done
echo "========================================"

if $DRY_RUN; then
    echo "⚠ Dry-run mode: no files were actually extracted."
else
    echo "✅ Extraction finished."
fi

