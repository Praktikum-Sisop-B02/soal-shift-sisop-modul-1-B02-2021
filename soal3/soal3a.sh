#!/bin/bash

file_name_template="Koleksi_"
download_url="https://loremflickr.com/320/240/kitten"


file_number=1
# download semua gambar
for ((num=1; num<=23; num=$num+1))
do
    # download gambar
    printf -v file_number_string "%02d" $file_number
    file_name="$file_name_template$file_number_string"
    wget -O "$file_name" $download_url -a "Foto.log"

    # cek gambar duplikat atau nggak
    grep 'Location: /cache/resized' "Foto.log" > "location.log"

    last_location_downloaded=$(cat location.log | tail -1)
    match_count=$(grep -cF "$last_location_downloaded" "location.log")
    
    if [ $match_count -ne 1 ]
    then
        rm $file_name
        continue
    fi
    
    file_number=$(($file_number + 1))
done