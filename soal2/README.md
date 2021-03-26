# soal-shift-sisop-modul-1-B02-2021

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
