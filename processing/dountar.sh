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
mv $name ${y}${m}${d}A.$l1$l2$l3$l4$l5$l6
echo ${y}${m}${d}A.$l1$l2$l3$l4$l5$l6
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

cd ../
cd ../
done
