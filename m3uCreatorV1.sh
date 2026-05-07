#!/usr/bin/env bash

PLAYLIST_DIR="./playlists"
mkdir -p "$PLAYLIST_DIR"

BASE_DIR="$(pwd)"

find . -type d -not -path "./playlists*" | while read -r dir; do
    files=()

    while IFS= read -r -d '' file; do
        files+=("$file")
    done < <(find "$dir" -maxdepth 1 -type f \( \
        -iname "*.mp3" -o -iname "*.flac" -o -iname "*.wav" -o -iname "*.m4a" -o -iname "*.ogg" \
    \) -print0)

    [ ${#files[@]} -eq 0 ] && continue

    # clean name: ./rock/90s -> rock_90s
    name=$(echo "$dir" | sed 's|^\./||; s|/|_|g')

    playlist="$PLAYLIST_DIR/${name}.m3u"
    : > "$playlist"

    for file in "${files[@]}"; do
        echo "$BASE_DIR/${file#./}" >> "$playlist"
    done

    echo "Created: $playlist"
done
