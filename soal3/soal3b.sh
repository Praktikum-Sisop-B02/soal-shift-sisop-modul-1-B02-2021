#!/bin/bash
#crontab :
# 0 20 1/7,2/4 * * /home/fwe/Documents/SISOPS/Codes/Soal Shift Modul 1/soal-shift-sisop-modul-1-B02-2021/soal3/soal3b.sh

folderName=$(date '+%d-%m-%Y')
if [ ! -d "$folderName" ]
then
	mkdir "$folderName"
fi

file_name_template="Koleksi_"
download_url="https://loremflickr.com/320/240/kitten"


file_number=1
# download semua gambar
for ((num=1; num<=23; num=$num+1))
do
    # download gambar
    printf -v file_number_string "%02d" $file_number
    file_name="$file_name_template$file_number_string"
    image_file_path="$folderName/$file_name"
    wget -O "$image_file_path" $download_url -a "$folderName/Foto.log"

    # cek gambar duplikat atau nggak
    grep 'Location: /cache/resized' "$folderName/Foto.log" > "$folderName/location.log"

    last_location_downloaded=$(cat "$folderName/location.log" | tail -1)
    match_count=$(grep -cF "$last_location_downloaded" "$folderName/location.log")
    
    if [ $match_count -ne 1 ]
    then
        rm "$image_file_path"
        continue
    fi
    
    file_number=$(($file_number + 1))
done