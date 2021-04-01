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
echo "Error, count" > error_massage.csv
cat hasilB.txt | sort -nr  >> error_massage_temp.csv
sed 's/$/,/' error_massage_temp.csv > error_massage_temp_with_comma.csv
perl -lane 'push @F, shift @F; print "@F"' error_massage_temp_with_comma.csv >> error_massage.csv

#Nomer E
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
