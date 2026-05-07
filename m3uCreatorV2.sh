#!/usr/bin/env bash

PLAYLIST_DIR="./playlists"
mkdir -p "$PLAYLIST_DIR"

# loop only top-level folders
for dir in */; do
    dir="${dir%/}"

    playlist="$PLAYLIST_DIR/${dir}.m3u"
    : > "$playlist"

    # find all audio files recursively
    find "$dir" -type f \( \
        -iname "*.mp3" -o -iname "*.flac" -o -iname "*.wav" -o -iname "*.m4a" -o -iname "*.ogg" \
    \) | sort | while read -r file; do
        # make path relative to playlists folder
        echo "../$file" >> "$playlist"
    done

    # remove empty playlist
    [ ! -s "$playlist" ] && rm -f "$playlist" && continue

    echo "Created: $playlist"
done
