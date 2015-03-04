#! /bin/bash
# moverange.sh
#
# Moves files within the specified epicentral range to ./outofrange
#
# David Stansby 2015

min=$1
mkdir outofrange

for seis in `ls *.s_fil`
do
	# Extract epicentral distance
	#echo echo on > sacmac.m
	echo rh $seis > sacmac.m
	echo "setbb gcarc &1,gcarc&" >> sacmac.m
	echo "sc echo \" %gcarc \" > seisdetails.dat" >>sacmac.m
	echo "quit" >> sacmac.m

	/usr/local/sac/bin/sac sacmac.m
	rm sacmac.m
	gcarc=`awk '{print $1}' seisdetails.dat`
	rm -fr seisdetails.dat

	# Extract first three digits of angle
	gcarc=${gcarc:0:3}
 	echo $gcarc

	if [ $gcarc -lt $min ]; then
		mv $seis outofrange
	fi
done
