# https://unix.stackexchange.com/questions/19654/how-do-i-change-the-extension-of-multiple-files

for file in *.zip; do
    mv -- "$file" "${file%.cbz}.zip"
done
