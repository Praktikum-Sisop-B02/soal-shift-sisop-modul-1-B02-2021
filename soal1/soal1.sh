#!/bin/bash

#Nomer A
cat syslog.log | cut -d' ' -f 6- | sort -s > hasilA.txt

#Nomer B
cat hasilA.txt | grep ERROR > temp1.txt
cat temp1.txt | cut -d'(' -f 1 > temp2.txt
cat temp2.txt | cut -d' ' -f 2- > temp3.txt
cat temp3.txt | sort -s| uniq -c > hasilB.txt

#Nomer C
cat hasilA.txt | grep INFO > temp4.txt
cat temp4.txt | cut -d'(' -f 2 | cut -d')' -f 1 > temp5.txt
cat temp5.txt | cut -d' ' -f 2- > temp6.txt
cat temp6.txt | sort -s| uniq -c > HasilCtemp.txt
perl -lane 'push @F, shift @F; print "@F"' HasilCtemp.txt > hasilC.txt
cat temp1.txt | cut -d'(' -f 2 | cut -d')' -f 1 > temp7.txt
cat temp7.txt | cut -d' ' -f 2- > temp8.txt
cat temp8.txt | sort -s| uniq -c > HasilC2temp.txt
perl -lane 'push @F, shift @F; print "@F"' HasilC2temp.txt > hasilC2.txt

#Nomer D
echo "Error count" > error_massage.csv
cat hasilB.txt | sort -nr  >> error_massage_temp.csv
perl -lane 'push @F, shift @F; print "@F"' error_massage_temp >> error_massage.csv

#Nomer E
echo "Username INFO ERROR" > user_statistic.csv
join hasilC.txt hasilC2.txt > user_temp.txt
cat user_temp.txt | sort -s >> user_statistic.csv
while IFS=" " read -a line;
do
 for i in {0,1};
  do
   line[$i]+=",";
  done
 echo "${line[@]}"
done < user_statistic.csv
