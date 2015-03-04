for file in *fil
do

echo $file > test1
date=`awk -F '.' '{print $1}' test1`
rm -fr test1

ls ../../../ > test1
grep $date test1 > test2
name=`awk -F'.' '{print $2}' test2`
rm -fr test1 test2

pwd > test1
epi=`awk -F'/' '{print $NF}' test1`
rm -fr test1

echo echo on > sacmac.m
echo rh $file >> sacmac.m
echo "setbb stat &1,kstnm&" >> sacmac.m
echo "setbb stla &1,stla&" >> sacmac.m
echo "setbb stlo &1,stlo&" >> sacmac.m
echo "setbb evla &1,evla&" >> sacmac.m
echo "setbb evlo &1,evlo&" >> sacmac.m
echo "setbb evdp &1,evdp&" >> sacmac.m
echo "setbb time &1,kztime&" >> sacmac.m
echo "sc echo \" %stat %evla %evlo %evdp  %stla %stlo %time \" > seisdetails.dat" >>sacmac.m
echo "quit" >> sacmac.m

/usr/local/sac/bin/sac sacmac.m
rm -fr sacmac.m

stat=`awk '{print $1}' seisdetails.dat`
evla=`awk '{print $2}' seisdetails.dat`
evlo=`awk '{print $3}' seisdetails.dat`
evdp=`awk '{print $4/1000}' seisdetails.dat`
stla=`awk '{print $5}' seisdetails.dat`
stlo=`awk '{print $6}' seisdetails.dat`
time=`awk '{print $7}' seisdetails.dat`

echo $stla $stlo > ${stat}.card
echo $evla $evlo > ${date}.${name}.dat
echo $evdp > ${date}.${name}.depth
echo $time > ${date}.${name}.time

done

ls *fil > test1
awk -F '.' '{print $2}' test1 > test2
wc -l test2 > number
num=`awk '{print $1}' number`
rm -fr number
if test "$num" -ge "89"
then
awk '0<NR && NR<=89 {print $0}' test2 > test2_1
awk '90<=NR {print $0}' test2 > test2_2
awk '{for (f = 1; f <= NF; f++) { a[NR, f] = $f }  } NF > nf { nf = NF } END {for (f = 1; f <= nf; f++) {for (r = 1; r <= NR; r++) {printf a[r, f] (r==NR ? RS : FS)} }}' test2_1 > test1_1
awk '{for (f = 1; f <= NF; f++) { a[NR, f] = $f }  } NF > nf { nf = NF } END {for (f = 1; f <= nf; f++) {for (r = 1; r <= NR; r++) {printf a[r, f] (r==NR ? RS : FS)} }}' test2_2  > test1_2
sed -i 's/ /,/g' test1_1
sed -i 's/ /,/g' test1_2
mv -f test1_1 ${date}.${name}.${epi}_1
mv -f test1_2 ${date}.${name}.${epi}_2
else
awk '{for (f = 1; f <= NF; f++) { a[NR, f] = $f }  } NF > nf { nf = NF } END {for (f = 1; f <= nf; f++) {for (r = 1; r <= NR; r++) {printf a[r, f] (r==NR ? RS : FS)} }}' test2  > test1
sed -i 's/ /,/g' test1
mv -f test1 ${date}.${name}.${epi}
rm -fr test2 seisdetails.dat
fi

mv -f ${date}.${name}.${epi}* ~/forstudents/wkbjAutomator/events
mv -f ${date}.${name}.dat ~/forstudents/wkbjAutomator/eventinfo
mv -f *card ~/forstudents/wkbjAutomator/stations
mv -f *time ~/forstudents/wkbjAutomator/times
mv -f *depth ~/forstudents/wkbjAutomator/depths

rm -fr test*


