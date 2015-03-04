#!/bin/bash  
#This script reads in your unfiltered sac files, and gives you the year and julian day output. From iris wilber you need to enter the year, julian day, hour, min and second. Then the script changes the origin time to this time for every sac file.

rm -fr tempmac tempmac1 test.dat test1.dat test2.dat


#echo echo on > tempmac
#echo "r *.A*.s" >> tempmac
#echo "lh kzdate" >> tempmac
#echo "quit" >> tempmac

#/usr/local/sac/bin/sac tempmac

pwd
echo "Enter date (yyyy jday hh mm ss msms)"
read date

for file in *.s
do
echo echo on > tempmac1
echo r $file >> tempmac1
echo "ch o gmt $date" >> tempmac1
echo "evaluate to orig &1,o * -1" >> tempmac1
echo "ch allt %orig iztype io" >> tempmac1
echo "w over" >> tempmac1
echo "quit" >> tempmac1

/usr/local/sac/bin/sac tempmac1
rm -fr tempmac1
done
