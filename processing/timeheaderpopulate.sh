#!/bin/bash

ln -s /raid1/ds598/src/ttimes/ak135000.hed
ln -s /raid1/ds598/src/ttimes/ak135000.tbl

for file in *_fil ; do
	echo echo on > get_ak135.m
	echo rh $file >> get_ak135.m
	echo eval to dp "0.001 * &1,evdp">> get_ak135.m	# Get event depth in km
	echo setbb del "&1,gcarc">> get_ak135.m		# Get distance from event to station in degrees
	echo "sc echo \" %dp %del \" > temp.dat" >> get_ak135.m	# Print to file
	echo quit >> get_ak135.m

	/usr/local/sac/bin/sac get_ak135.m $file

	dp=`awk '{print $1}' temp.dat`
	del=`awk '{print $2}' temp.dat`

	rm get_ak135.m
/raid1/ds598/src/ttimes/ttimes <<END
ak135000
PKP
PKiKP
pPKP

$dp
$del
-10
-10
quit
END

	id1=PKIKP
	id2=PKiKP
	id3=pPKIKP


	vari1=`awk '{if ( $2 ~ /^PKPdf$/ ) print ($3 +0 ) }' dat`
	vari2=`awk '{if ( $2 ~ /^PKiKP$/ ) print ($3 +0 ) }' dat`
	vari3=`awk '{if ( $2 ~ /^pPKPdf$/ ) print ($3 +0 ) }' dat`

	if [ -n "$vari1" ]; then
		tim1=$vari1
		echo $tim1
	else
		tim1=-12345
	fi

	if [ -n "$vari2" ]; then
		tim2=$vari2
		echo $tim2
	else
		tim2=-12345
	fi

	if [ -n "$vari3" ]; then
		tim3=$vari3
		echo $tim3
	else
		tim3=-12345
	fi

	echo echo on > get_ak1351.m
	echo rh $file >> get_ak1351.m
	echo ch t1 $tim1 kt1 $id1 >> get_ak1351.m	# Set PKIKP arrival tims
	echo ch t2 $tim2 kt2 $id2 >> get_ak1351.m	# Set PKiKP arrival time
	echo ch t3 $tim3 kt3 $id3 >> get_ak1351.m	# Set pPKIKP arrival time
	echo wh over >> get_ak1351.m
	echo quit >> get_ak1351.m

	/usr/local/sac/bin/sac get_ak1351.m $file
	cp dat ttimesoutput_$file

	rm dat get_ak1351.m
done


mkdir ./ttimesinfo
mv ./ttimesoutput* ./ttimesinfo
rm -fr ttimesinfo temp.dat get_ak135.m get_ak1351.m ttim1.lis ak135000*
