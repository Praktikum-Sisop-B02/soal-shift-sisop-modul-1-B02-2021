# soal-shift-sisop-modul-1-B02-2021

## Soal Nomor 3

### A. Mengunduh 23 gambar, menyimpan log, melakukan pengecekan agar tidak ada gambar yang duplikat, tanpa ada penomoran yang hilang

#### Penyelesaian

```
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
```

#### Penjelasan

Dilakukan looping sebanyak 23 kali untuk mendownload gambar dari "https://loremflickr.com/320/240/kitten". Dimana pada setiap tahap looping akan dilakukan apakah gambar tersebut duplikat atau tidak.
Pengecekan duplikat atau tidak bisa dengan memanfaatkan log dari proses download. Dimana dapat dilihat dicontoh salah satu log adalah sebagai berikut :

```
--2021-03-25 11:17:20--  https://loremflickr.com/320/240/kitten
Resolving loremflickr.com (loremflickr.com)... 104.21.47.37, 172.67.170.91, 2606:4700:3034::6815:2f25, ...
Connecting to loremflickr.com (loremflickr.com)|104.21.47.37|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: /cache/resized/65535_50548809727_2bc4206b57_n_320_240_nofilter.jpg [following]
--2021-03-25 11:17:21--  https://loremflickr.com/cache/resized/65535_50548809727_2bc4206b57_n_320_240_nofilter.jpg
Reusing existing connection to loremflickr.com:443.
HTTP request sent, awaiting response... 200 OK
Length: 12648 (12K) [image/jpeg]
Saving to: ‘25-03-2021/Koleksi_02’

     0K .......... ..                                         100% 8.46M=0.001s
```

Informasi `Location: /cache/resized/65535_50548809727_2bc4206b57_n_320_240_nofilter.jpg [following]` dapat digunakan sebagai informasi apakah gambar sama atau tidak. Maka dari itu untuk mendapatkan semua informasi mengenai location yang sudah pernah di download. Dengan menggunakan `grep 'Location: /cache/resized' "Foto.log" > "location.log"` maka semua location yang sudah di download akan terdata pada location.log
Karena kita membutuhkan location yang paling akhir untuk dilakukan perbandingan maka dilakukan perintah `last_location_downloaded=$(cat location.log | tail -1)` dimana fungsi tail adalah untuk mendapatkan baris dari akhir file
Lalu akan dihitung kemunculan dari string location yang terakhir dengan perintah `match_count=$(grep -cF "$last_location_downloaded" "location.log")` jika lebih dari 1 maka mengindikasikan bahwa gambar tersebut duplikat, maka perlu dihapus, dan nomor file tidak di increment

```
if [ $match_count -ne 1 ]
    then
        rm $file_name
        continue
fi
```

Jika tidak kembar maka nomor file akan di increment

```
file_number=$(($file_number + 1))
```

### B. Membuat crontab sehari sekali pada jam 8 malam untuk tanggal-tanggal tertentu setiap bulan, yaitu dari tanggal 1 tujuh hari sekali, serta dari tanggal 2 empat hari sekali. Dimana gambar diletakan ke sebuah folder dengan nama tanggal (DD-MM-YYYY)

#### Penyelesaian

```
#!/bin/bash

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
```

Crontab :

```
0 20 1-31/7,2-31/4 * * /home/fwe/Documents/SISOPS/Codes/Soal\ Shift\ Modul\ 1/soal-shift-sisop-modul-1-B02-2021/soal3/soal3b.sh
```

#### Penjelasan

Sebelum script berjalan perlu dilakukan pengecekan terlebih dahulu apakah folder sudah ada atau belum menggunakan :

```
folderName=$(date '+%d-%m-%Y')
if [ ! -d "$folderName" ]
then
	mkdir "$folderName"
fi
```

Selebihnya sama dengan soal A kecuali penambahan path ke folder yang telah dibuat.

Untuk cron nya sendiri

```
0 20 1-31/7,2-31/4 * * /home/fwe/Documents/SISOPS/Codes/Soal\ Shift\ Modul\ 1/soal-shift-sisop-modul-1-B02-2021/soal3/soal3b.sh
```

adalah menjalankan script soal3b.sh sehari sekali pada jam 8 malam untuk tanggal-tanggal tertentu setiap bulan, yaitu dari tanggal 1 tujuh hari sekali, serta dari tanggal 2 empat hari sekali.

#### Kendala

Crontab `0 20 1/7,2/4 * * /home/fwe/Documents/SISOPS/Codes/Soal Shift Modul 1/soal-shift-sisop-modul-1-B02-2021/soal3/soal3b.sh` tidak di support

### C. Mendownload gambar kucing dan kelinci secara bergantian

#### Penyelesaian

```
#!/bin/bash

current_day=$(date '+%d')

if [ $(($current_day % 2)) -ne 0 ]
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
```

#### Penjelasan

Dilakukan penambahan perintah untuk melakukan pengecekan apakah tanggal saat ini ganjil atau genap, jika tanggal adalah genap maka akan mendownload gambar kelinci sedangkan bila tanggal ganjil akan mendownload gambar kucing.

```
current_day=$(date '+%d')

if [ $(($current_day % 2)) -ne 0 ]
then
    # kalau tanggal genap
    folderName="Kelinci_$(date '+%d-%m-%Y')"
    download_url="https://loremflickr.com/320/240/bunny"
else
    # kalau tanggal ganjil
    folderName="Kucing_$(date '+%d-%m-%Y')"
    download_url="https://loremflickr.com/320/240/kitten"
fi
```

### D. Memindahkan seluruh folder ke zip yang diberi nama “Koleksi.zip” dan mengunci zip tersebut dengan password berupa tanggal saat ini dengan format "MMDDYYYY"

#### Penyelesaian

```
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
```

#### Penjelasan

Script akan melakukan pengecekan apakah sudah terdapat sebuah file zip dengan nama "Koleksi.zip", jika ada maka akan di-Unzip dan file zip akan dihapus

```
unzip -qP "$password" "$zip_name"
rm -rf "$zip_name"
```

Jika tidak ada sebuah folder zip maka akan dilakukan ls pada direktori script dijalankan, dan akan dipilih folder yang memiliki awalan "Kucing*" atau "Kelinci*" yang diletakan pada file folder_koleksi.log, kemudian akan dilakukan looping kepada semuanya untuk di masukan ke dalam satu folder zip.

```
# masukin semu folder yang ada ke log
ls -a | grep "Kelinci_\|Kucing_" > folder_koleksi.log

for ((loop=1; loop<=$(wc -l < folder_koleksi.log); loop=$loop+1))
do
    folderName=$(head -$loop folder_koleksi.log | tail -1)
    zip -qrP "$password" "$zip_name" "$folderName"
    rm -rf "$folderName"
done
```

### E. Membuat crontab untuk zip setiap hari senin - jumat jam 7 pagi dan unzip setiap hari senin - jumat jam 6 sore.

#### Penyelesaian

```
0 7,18 * * 1-5 /home/fwe/Documents/SISOPS/Codes/Soal\ Shift\ Modul\ 1/soal-shift-sisop-modul-1-B02-2021/soal3/soal3d.sh
```

#### Penjelasan

Cron setiap jam 7.00 dan 18.00 dimana zip dan unzip sudah di handle oleh script soal3d
