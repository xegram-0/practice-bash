source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end
# yt-dlp video downloader
function yt
    yt-dlp -f "bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]" \
        --merge-output-format mp4 \
        -P "$HOME/Downloads" \
        $argv
end

# yt-dlp mp3 helper
alias ytmp3='yt-dlp -x --audio-format mp3 --audio-quality 0 --embed-metadata --embed-thumbnail -P ~/Downloads'

# suspend system
alias sleepnow='systemctl suspend'

