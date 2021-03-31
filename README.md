# soal-shift-sisop-modul-1-B02-2021
## Soal Nomor 1
Ryujin baru saja diterima sebagai IT support di perusahaan Bukapedia. Dia diberikan tugas untuk membuat laporan harian untuk aplikasi internal perusahaan, ticky. Terdapat 2 laporan yang harus dia buat, yaitu laporan daftar peringkat pesan error terbanyak yang dibuat oleh ticky dan laporan penggunaan user pada aplikasi ticky.

### A. Mengumpulkan informasi dari log aplikasi yang terdapat pada file syslog.log. Informasi yang diperlukan antara lain: jenis log (ERROR/INFO), pesan log, dan username pada setiap baris lognya. Karena Ryujin merasa kesulitan jika harus memeriksa satu per satu baris secara manual, dia menggunakan regex untuk mempermudah pekerjaannya. Bantulah Ryujin membuat regex tersebut.

#### Penyelesaian
```
cut syslog.log | cut -d' ' -f 6- | sort -s > hasilA.txt
```

#### Penjelasan
Di nomor A ini kita disuruh untuk mengumpulkan informasi dari file syslog.log yang dimana informasi tersebut Jenis Log (ERROR/INFO), pesan log, dan username pada setiap baris lognya. Disini penggunaan
```
cut syslog.log
```
ditujukan untuk mengambil semua data dari syslog.log. Kemudian dengan command cut
```
cut -d' ' -f 6-
```
untuk mengambil data dengan delimiter spasi(" ") dan dimulai dari field ke 6 yaitu dari kata ERROR dan INFO sampai ke field terakhir. Setelah itu kita sorting secara ascending dengan menggunakan ``` sort -s ``` dan meletakkan hasilnya ke file sementara yaitu file hasilA.txt

#### Kendala
Kendala yang saya temui di nomor 1a ini adalah bagaimana cara untuk men-store hasil dari nomor 1a dan kemudian saya membuat file temporary yang berfungsi untuk menyimpan hasil nomor 1a agar bisa dipakai untuk nomor selanjutnya

### B. Kemudian, Ryujin harus menampilkan semua pesan error yang muncul beserta jumlah kemunculannya.

#### Penyelesaian
```
cat hasilA.txt | grep ERROR > temp1.txt
cat temp1.txt | cut -d'(' -f 1 > temp2.txt
cat temp2.txt | cut -d' ' -f 2- >temp3.txt
cat temp3.txt | sort -s | uniq -c > hasilB.txt
```

#### Penjelasan
Di nomor B ini kita disuruh menampilkan semua pesan error dan jumlah kemunculan dari pesan error tersebut. Command ```cat hasilA.txt``` akan mengambil data dari file hasilA.txt kemudian digunakan command grep ``` grep ERROR``` untuk mengambil semua log yang memiliki jenis log ERROR dan di simpan di file temp1.txt
Kemudian, 
``` cat temp1.txt | cut -d'(' -f 1 > temp2.txt ```
command tersebut akan membaca file temp1.txt dan mengambil data sampai sebelum tanda "(" yaitu tanda sebelum username. Karena pada file temp1.txt masih terdapat username yang tidak diinginkan pada soal, dan kemudian disimpan di file temp3.txt.
Pada command
```
cat temp2.txt | cut -d' ' -f 2- > temp3.txt
```
merupakan command untuk menghilangkan field yang mengandung kata ERROR
Setelah itu, pada command
```
cat temp3.txt | sort -s| uniq -c > hasilB.txt
```
melakukan pengambilan data di file temp2.txt dan men-sorting nya secara ascending kemudian command ``` uniq -c ``` melakukan penghitungan jumlah dari error yang terdapat pada file temp2.txt dan melakukan group by berdasarkan nama errornya dan men-store hasilnya ke file hasilB.txt

#### Kendala
Kendala nya pada soal ini saya kesulitan untuk membuat formatting (Nama_log) (Jumlah), kemudian saya menggunakan command ``` perl -lane 'push @F, shift @F; print "@F"' ``` untuk membuat hal tersebut

### C. Ryujin juga harus dapat menampilkan jumlah kemunculan log ERROR dan INFO untuk setiap user-nya.

#### Penyelesaian
```
cat hasilA.txt | grep INFO > temp4.txt
cat temp4.txt | cut -d'(' -f 2 | cut -d')' -f 1 > temp5.txt
cat temp5.txt | cut -d' ' -f 2- > temp6.txt
cat temp6.txt | sort -s| uniq -c > hasilCtemp.txt
perl -lane 'push @F, shift @F; print "@F"' hasilCtemp.txt > hasilC.txt
cat temp1.txt | cut -d'(' -f 2 | cut -d')' -f 1 > temp7.txt
cat temp7.txt | cut -d' ' -f 2- > temp8.txt
cat temp8.txt | sort -s| uniq -c > hasilC2temp.txt
perl -lane 'push @F, shift @F; print "@F"' hasilC2temp.txt > hasilC2.txt
```

### Penjelasan
Pada command ```cat hasilA.txt | grep INFO > temp4.txt``` akan mengambil data yang berkaitan dengan INFO. 
```
cat temp4.txt | cut -d'(' -f 2 | cut -d')' -f 1 > temp5.txt
``` 
hanya akan mengeprint INFO dan usernamenya saja kemudian
```
cat temp5.txt | cut -d' ' -f 2- > temp6.txt
```
akan meng-skip field dengan kata INFO sehingga cuma usernamenya saja. Dan kemudian
```
cat temp6.txt | sort -s| uniq -c > hasilCtemp.txt
```
Akan menghitung jumlah INFO nya berdasarkan username dan di group by dengan username.
```
perl -lane 'push @F, shift @F; print "@F"' hasilCtemp.txt > hasilC.txt
```
digunakan untuk menukar field pertama menjadi field terakhir karena pada file hasilCtemp.txt itu masih tidak sesuai dengan formatting jawaban.
Begotu juga dengan command
```
cat temp1.txt | cut -d'(' -f 2 | cut -d')' -f 1 > temp7.txt
cat temp7.txt | cut -d' ' -f 2- > temp8.txt
cat temp8.txt | sort -s| uniq -c > hasilC2temp.txt
perl -lane 'push @F, shift @F; print "@F"' hasilC2temp.txt > hasilC2.txt
```
sama dengan penjelasan diatas.

#### Kendala
Kendala yang ditemukan yaitu cara menyingkat kode diatas karena terkesan terlalu banyak temporary file nya.

### D. Semua informasi yang didapatkan pada poin b dituliskan ke dalam file error_message.csv dengan header Error,Count yang kemudian diikuti oleh daftar pesan error dan jumlah kemunculannya diurutkan berdasarkan jumlah kemunculan pesan error dari yang terbanyak.

#### Penyelesaian
```
echo "Error, count" > error_massage.csv
cat hasilB.txt | sort -nr  >> error_massage_temp.csv
sed 's/$/,/' error_massage_temp.csv > error_massage_temp_with_comma.csv
perl -lane 'push @F, shift @F; print "@F"' error_massage_temp_with_comma.csv >> error_massage.csv
```

#### Penjelasan
Pada command
```
Echo "Count, Error" > error_massage.csv
```
mencetak header yang diinginkan, tetapi sesuai dengan nomor 1B yaitu saya tidak dapat membuat sesuai format soal makanya saya membuatnya seperti ini, dan menyimpan hasilnya ke file error_massage.csv.
Kemudian pada command
```
cat hasilB.txt | sort -nr >> error_massage_temp.csv
```
melakukan pengambilan data dari file hasilB.txt kemuadian mensorting nya berdasarkan jumlah error terbanyak dan menyimpan hasilnya pada file error_massage_temp.csv.
Pada command
```
sed 's/$/,/' error_massage_temp.csv > error_massage_temp_with_comma.csv
```
digunakan untuk menambahkan koma pada file tersebut
Dan untuk command
```
perl -lane 'push @F, shift @F; print "@F"' error_massage_temp_with_comma.csv >> error_massage.csv
```
mengubah field pertama menjadi field terakhir.
#### Kendala
Pada soal ini kendalanya yaitu membuat koma pada output file nya.

### E. Semua informasi yang didapatkan pada poin c dituliskan ke dalam file user_statistic.csv dengan header Username,INFO,ERROR diurutkan berdasarkan username secara ascending.

#### Penyelesaian
```
echo "Username, INFO, ERROR" > user_statistic.csv
join -a 1 -a 2 -e0 -o 0 1.2 2.2 hasilC.txt hasilC2.txt > user_temp.txt
while IFS=" " read -a line;
do
 for i in {0,1};
  do
   line[$i]+=",";
  done
 echo "${line[@]}"
done < user_temp.txt >> user_statistic.csv
```

#### Penjelasan
Pada command
```
echo "Username, INFO, ERROR" > user_statistic.csv
```
adalah pembuatan header pada file user_statistic.csv.
Dan pada command
```
join -a 1 -a 2 -e0 -o 0 1.2 2.2 hasilC.txt hasilC2.txt > user_temp.txt
```
merupakan comman yang digunakan untuk menggabung 2 file yang berbeda. Untuk option -a 1 dan -a 2 merupakan outer join yang mana ketika menggabungkan 2 file maka file yang tidak memiliki pasangan juga ikut di tampilkan, dan untuk angka 1 dan 2 itu sendiri menandakan bahwa pada file 1 dan file 2. Untuk -e option digunakan untuk mereplace atau mengganti data yang bernilai empty dengan sesuatu, disini diganti dengan 0. Kemudian option -o menandakan bahwasanya output yang akan dikeluarkan itu, dimulai dari 0 yaitu join fieldnya, 1.2 yaitu field ke 2 dari file 1, dan 2.2 yaitu field ke 2 dari file 2.
Kemudian untuk
```
while IFS=" " read -a line;
do
  for i in {0,1};
   do
   line[$i]+=",";
   done
  echo "${line[@]}"
done < user_temp.txt >> user_statistic.csv
```
merupakan command untuk menambahkan koma pada setiap field sehingga sama dengan output yang diminta.

#### Kendala
Untuk join 2 file yang dimana ada data di file tersebut yang unpair atau tidak berpasangan sehingga tidak dapat di tampilkan pada file outputnya, sehingga perlu ditambah command ``` join -a 1 -a 2 -e0 -o 0 1.2 2.2 hasilC.txt hasilC2.txt > user_temp.txt ``` agar data yang tidak berpasangan tersebut dapat di tampilkan dan data yang tidak memiliki pasangan akan diganti dengan 0.

## Soal Nomor 2
Steven dan Manis mendirikan sebuah startup bernama “TokoShiSop”. Sedangkan kamu dan Clemong adalah karyawan pertama dari TokoShiSop. Setelah tiga tahun bekerja, Clemong diangkat menjadi manajer penjualan TokoShiSop, sedangkan kamu menjadi kepala gudang yang mengatur keluar masuknya barang.

Tiap tahunnya, TokoShiSop mengadakan Rapat Kerja yang membahas bagaimana hasil penjualan dan strategi kedepannya yang akan diterapkan. Kamu sudah sangat menyiapkan sangat matang untuk raker tahun ini. Tetapi tiba-tiba, Steven, Manis, dan Clemong meminta kamu untuk mencari beberapa kesimpulan dari data penjualan “Laporan-TokoShiSop.tsv”.

### A. Steven ingin mengapresiasi kinerja karyawannya selama ini dengan mengetahui Row ID dan profit percentage terbesar (jika hasil profit percentage terbesar lebih dari 1, maka ambil Row ID yang paling besar). Karena kamu bingung, Clemong memberikan definisi dari profit percentage. Cost Price didapatkan dari pengurangan Sales dengan Profit. (Quantity diabaikan).

#### Penyelesaian

```bash 
LC_ALL=C awk -F"\t" '
BEGIN{}
{
    profit=$21
    sales=$18
    pp=profit/(sales-profit)*100
    if(Maxpp <= pp){
        Maxpp=pp
        Maxid=$1
}}

END { printf("Transaksi terakhir dengan profit percentage terbesar yaitu %d dengan persentase %.2f%%.\n\n", Maxid, Maxpp)}
' /home/arkan/Documents/Modul1/Laporan-TokoShiSop.tsv > hasil.txt
```

#### Penjelasan
Di soal 2 ini kita mengimplementasikan salah satu pelajaran di modul 1 yaitu AWK. Setelah kemarin asistensi dengan mas rafi, ternyata AWK bisa dijalankan dengan bash, jadi saya coba mempraktekan AWK ini pada .sh file. soal ini ingin kita mengeluarkan output row id dan profit percentage terbesar. profit percentage bisa didapat dari rumus yang sudah disediakan pada soal. row id didapat dari row pertama pada file Laporan-TokoShiSop.tsv sedangkan profit dan sales (yang merupakan komponen dalam mencari profit percentage) didapat dari row ke 21 dan 18. jadi kita mengambil data dari file tersebut dengan menggunakan syntax ```$row``` . saya menggunakan if untuk menset maxpp(profit percentage terbesar) dan maxid(id terbesar). karna di soal ditulis row id diambil yang terbesar, maka saya pakai maxpp<=pp karena profit percentage terbesar ada di angka 100% dan yang punya 100% itu ada banyak, jadi saat maxpp bertemu dengan 100% lagi, dia akan mereplace si maxid tersebut. selanjutnya saya print persis seperti yang dijerlaskan oleh sub nomor e.

#### Kendala
Di soal 2a ini tidak ada yang terlalu menyulitkan saya untuk mengodingnya, namun banyak halangan yang saya temui di soal ini. yang paling lama saya selesaikan adalah perlunya LC_ALL=C di sebelum AWK. permasalahan ini sebenarnya sudah pernah saya temui di soal latihan modul 1, namun saya tidak terpikir menjumpainya lagi disini. ini disebabkan oleh VM Oracle virtual box yang saya gunakan tidak dapat membedakan '.' dan ',' jadi localnya harus di set seperti itu. selain itu hanya masalah tidak terbiasanya saya dengan syntax awk jadi sering salah syntax. 

### B. Clemong memiliki rencana promosi di Albuquerque menggunakan metode MLM. Oleh karena itu, Clemong membutuhkan daftar nama customer pada transaksi tahun 2017 di Albuquerque.

#### Penyelesaian

```bash 
awk -F"\t" '
BEGIN{}
{
    if($10=="Albuquerque" && $2~"2017"){
        total[$7]++;
    }
}

END {
{
    printf("Daftar nama customer di Albuquerque pada tahun 2017 antara lain:\n")
    for(nama in total){
    printf ("%s\n", nama);
}}}
' /home/arkan/Documents/Modul1/Laporan-TokoShiSop.tsv >> hasil.txt
```

#### Penjelasan
soal ini meminta kita mengoutputkandaftar nama cutomer di alburquerque pada tahun 2017, jadi kita memanggil data dari file Laporan-TokoShiSop.tsv di row 10 yang berisi ama nama kota untuk memanggil kota alburquerque dan row 2 yang berisi order id untuk memanggil tahunnya. namun karena tahunnya diapit oleh isi dari order id yang lain, maka saya tidak menggunakan '==' melainkan menggunakan '~'. ini berguna untuk mengambil 2017nya dari seluruh data contohnya CA-2017-114412, jika kita menggunakan ==, 2017 tidak akan terdata sedangkan jika menggunakan ~, 2017nya akan diambil dari data penuhnya. lalu saya outputkan daftar nama tersebut dengan loop menggunakan batasan total yang di increment di if tadi.

#### Kendala
saya beberapa kali menggunakan == dan tidak keambil 2017nya, setelah mencari tahu, ternyata perlu memakai ~.

### C. TokoShiSop berfokus tiga segment customer, antara lain: Home Office, Customer, dan Corporate. Clemong ingin meningkatkan penjualan pada segmen customer yang paling sedikit. Oleh karena itu, Clemong membutuhkan segment customer dan jumlah transaksinya yang paling sedikit.

#### Penyelesaian

```bash
awk -F"\t" '
BEGIN{}
{
    seg=$8
    if(seg~"Consumer") cons++
    else if(seg~"Corporate") corp++
    else if(seg~"Home Office") home++
}

END {
{
    if(cons<corp){
        if(cons<home){
            minseg="Consumer"
            minorder=cons
            }
        else {
            minseg="Home Office"
            minorder=home
        }
    }
    else if(corp<home){
        minseg="Corporate"
        minorder=corp
        }
    else {
        minseg="Home Office"
        minorder=home
        }
    printf("\nTipe segmen customer yang penjualannya paling sedikit adalah %s dengan %d transaksi.\n", minseg, minorder);
}}
' /home/arkan/Documents/Modul1/Laporan-TokoShiSop.tsv >> hasil.txt
```

#### Penjelasan
dibutuhkan output segment customer dengan penjualan paling sedikit, jadi perlu dicari penjualan tiap segmentnya. hal ini dicari dengan mengambil row ke 8 lalu mendeclare suatu counter tiap row ke 8 menyentuk tiap2 segmentnya. setelah seluruh counter tiap selesai, kita mensortnya dengan if else saja karena hanya 3 variabel yang akan di sort. setelah didapat yang paling kecil tinggal di print sesuai sub nomor e. 


### D. TokoShiSop membagi wilayah bagian (region) penjualan menjadi empat bagian, antara lain: Central, East, South, dan West. Manis ingin mencari wilayah bagian (region) yang memiliki total keuntungan (profit) paling sedikit dan total keuntungan wilayah tersebut.

#### Penyelesaian

```bash
awk -F"\t" '
BEGIN{}
{
   if($13~"West") {a+=$21}
   else if($13~"South") {b+=$21}
   else if($13~"East") {c+=$21}
   else if($13~"Central") {d+=$21}
   
}

END {
{   if(a<b && a<c && a<d){
       minreg="West"
       minp=a
   }
    if(b<c && b<d && b<a){
       minreg="South"
       minp=b
   }
    if(c<a && c<b && c<d){
       minreg="East"
       minp=c
   }
    if(d<a && d<b && d<c){
       minreg="Central"
       minp=d
   }
    printf("\nWilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah %s dengan total keuntungan %d",minreg,minp);
}}
' /home/arkan/Documents/Modul1/Laporan-TokoShiSop.tsv >> hasil.txt
```

#### Penjelasan
mirip dengan nomor 3 namun ini 4 variabel. jadi karena diperlukannya region dengan keuntungan paling sedikit, maka diperlukan data region(row 18) dan profit(row 21). profit dijumlahkan dengan counter yang ditambahkan tiap suatu region terpanggil, lalu di sort dengan if. lalu di print berdasarkan sub soal e.


### E. Kamu diharapkan bisa membuat sebuah script yang akan menghasilkan file “hasil.txt” yang memiliki format sebagai berikut:
```
Transaksi terakhir dengan profit percentage terbesar yaitu *ID Transaksi* dengan persentase *Profit Percentage*%.

Daftar nama customer di Albuquerque pada tahun 2017 antara lain:
*Nama Customer1*
*Nama Customer2* dst

Tipe segmen customer yang penjualannya paling sedikit adalah *Tipe Segment* dengan *Total Transaksi* transaksi.

Wilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah *Nama Region* dengan total keuntungan *Total Keuntungan (Profit)*
```

#### Penyelesaian

```
Transaksi terakhir dengan profit percentage terbesar yaitu 9952 dengan persentase 100.00%.

Daftar nama customer di Albuquerque pada tahun 2017 antara lain:
Benjamin Farhat
David Wiener
Michelle Lonsdale
Susan Vittorini

Tipe segmen customer yang penjualannya paling sedikit adalah Home Office dengan 1783 transaksi.

Wilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah Central dengan total keuntungan 39706
```




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

Jika tidak ada sebuah folder zip maka akan dilakukan ls pada direktori script dijalankan, dan akan dipilih folder yang memiliki awalan "Kucing_" atau "Kelinci_" yang diletakan pada file folder_koleksi.log, kemudian akan dilakukan looping kepada semuanya untuk di masukan ke dalam satu folder zip.

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
