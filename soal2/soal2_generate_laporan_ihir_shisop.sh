#!/bin/bash

#2A =================================================
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
' /home/arkan/Documents/Modul1/Laporan-TokoShiSop.tsv | tee -a hasilA.txt hasil.txt


#2B ==================================================
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
    printf("\n");
}}}
' /home/arkan/Documents/Modul1/Laporan-TokoShiSop.tsv | tee -a hasilB.txt hasil.txt

#2C ==================================================
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
    printf("Tipe segmen customer yang penjualannya paling sedikit adalah %s dengan %d transaksi.\n\n", minseg, minorder);
}}
' /home/arkan/Documents/Modul1/Laporan-TokoShiSop.tsv | tee -a hasilC.txt hasil.txt

#2D ==================================================
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
    printf("Wilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah %s dengan total keuntungan %f\n",minreg,minp);
}}
' /home/arkan/Documents/Modul1/Laporan-TokoShiSop.tsv | tee -a hasilD.txt hasil.txt