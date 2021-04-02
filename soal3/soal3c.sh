#!/bin/bash

current_day=$(date '+%d')

count_kelinci=`ls -a | grep -c "Kelinci_"`
count_kucing=`ls -a | grep -c "Kucing_"`

if [ $count_kelinci -le $count_kucing ]
then
    # kalau tanggal genap
    folderName="Kelinci_$(date '+%d-%m-%Y')"
    download_url="https://loremflickr.com/320/240/bunny"
else
    # kalau tanggal ganjil
    folderName="Kucing_$(date '+%d-%m-%Y')"
    download_url="https://loremflickr.com/320/240/kitten"
fi

if [ ! -d "$folderName" ]
then
	mkdir "$folderName"
fi

file_name_template="Koleksi_"

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