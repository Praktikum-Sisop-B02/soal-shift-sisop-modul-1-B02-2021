#!/bin/bash

zip_name="Koleksi.zip"
password=$(date '+%m%d%Y')

if [ ! -f "$zip_name" ]
then
	# masukin semu folder yang ada ke log
    ls -a | grep "Kelinci_\|Kucing_" > folder_koleksi.log

    for ((loop=1; loop<=$(wc -l < folder_koleksi.log); loop=$loop+1))
    do
        folderName=$(head -$loop folder_koleksi.log | tail -1)
        zip -qrP "$password" "$zip_name" "$folderName"
        rm -rf "$folderName"
    done
else
    unzip -qP "$password" "$zip_name"
    rm -rf "$zip_name"
fi

