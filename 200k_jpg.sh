# https://superuser.com/questions/644272/how-do-i-delete-all-files-smaller-than-a-certain-size-in-all-subfolders
for file in *.jpg; do
    find . -type f -name "*.jpg" -size -1000k -delete;
    find . -type f -name "*.jpeg" -size -1000k -delete;
    find . -type f -name "*.png" -size -1000k -delete;
done

