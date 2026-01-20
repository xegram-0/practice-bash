find . ! -name "*.zip" -type f -print0 | parallel -0 -N 5 zip arch{#} {}
