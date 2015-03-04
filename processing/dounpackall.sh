for file in *tgz
do
tar -zxf $file
echo $file > test
name=`awk -F'.' '{print $1}' test`
mv $file $name
echo $name > test
y=`awk -F'-' '{print $1}' test`
m=`awk -F'-' '{print $2}' test`
d=`awk -F'-' '{print $3}' test`
l1=`awk -F'-' '{print $5}' test`
l2=`awk -F'-' '{print $6}' test`
l3=`awk -F'-' '{print $7}' test`
l4=`awk -F'-' '{print $8}' test`
l5=`awk -F'-' '{print $9}' test`
l6=`awk -F'-' '{print $10}' test`
mv $name untarred/${y}${m}${d}A.$l1$l2$l3$l4$l5$l6
rm -fr test
done

for dir in 20*
do
cd $dir
mkdir polezeroes orig
mv SACPZ* polezeroes
mv *BHZ* orig
pwd > test
name=`awk -F'/' '{print $NF}' test`
echo $name > test
date=`awk -F'.' '{print $1}' test`
rm -fr test
cd orig
for file in *SAC
do
echo $file > test
stat=`awk -F'.' '{print $2}' test`
mv $file $date.$stat.BHZ.s
rm -fr test
done
echo echo on > tempmac
echo "r *.A*.s" >> tempmac
echo "lh kzdate" >> tempmac
echo "quit" >> tempmac

/usr/local/sac/bin/sac tempmac

pwd
echo "enter date"
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

~/forstudents/fordavid/dofiltshort.sh *.s
cd ../
mkdir filt
mv orig/*fil filt
cd ../
done

