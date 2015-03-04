#! /bin/bash

#Script to determine hemispheres. Do loop over *fil files, sac macro to obtain headers, TauP to get pierce points, if loop to determine which hemisphere.

rm -f≈y sacmac.m stationdetails.dat seisdetails.dat output.dat timedetails.dat

for file in filt/*fil
do

	#echo $file > file.dat
	#cmtcode=`awk -F"/" '{print $1}' file.dat`

	#echo "enter seismogram"
	#read seis

	echo echo on > sacmac.m
	echo rh $file >> sacmac.m
	echo "setbb gcarc &1,gcarc&" >> sacmac.m
	echo "setbb stat &1,kstnm&" >> sacmac.m
	echo "setbb depth &1,evdp&" >> sacmac.m
	echo "setbb stla &1,stla&" >> sacmac.m
	echo "setbb stlo &1,stlo&" >> sacmac.m
	echo "setbb evla &1,evla&" >> sacmac.m
	echo "setbb evlo &1,evlo&" >> sacmac.m
	echo "setbb time &1,kztime&" >> sacmac.m
	echo "sc echo \" %gcarc %stla %stlo %evla %evlo %depth %stat %time \" >> seisdetails.dat" >>sacmac.m
	echo "quit" >> sacmac.m

	/usr/local/sac/bin/sac sacmac.m

	for file in seisdetails.dat
	do
		gcarc=`awk '{print $1 }' seisdetails.dat`
		stla=`awk '{ print $2 }' seisdetails.dat`
		stlo=`awk '{ print $3 }' seisdetails.dat`
		evla=`awk '{ print $4 }' seisdetails.dat`
		evlo=`awk '{ print $5 }' seisdetails.dat`
		depth=`awk '{ print $6/1000 }' seisdetails.dat`
		stat=`awk '{ print $7 }' seisdetails.dat`

		#echo $stla $stlo $evla $evlo $depth $stat

		# Get the bottoming point for this model
		/usr/local/TauP-2.1.1/bin/taup_pierce -turn -h $depth -ph PKIKP -sta  $stla $stlo -mod ak135 -evt $evla $evlo -o output.dat

		turndep=`awk '{if ( NR ==2 ) print $2}' output.dat`
		turnlat=`awk '{if ( NR ==2 ) print $4}' output.dat`
		turnlon=`awk '{if ( NR ==2 ) print $5}' output.dat`

		# Get the pierce points for the inner core

		/usr/local/TauP-2.1.1/bin/taup_pierce -h $depth -ph PKIKP -mod ak135 -sta  $stla $stlo  -evt $evla $evlo -o output.dat -nodiscon -pierce 5153.5

		inlat=`awk '{if ( NR ==2 ) print $4}' output.dat`
		outlat=`awk '{if ( NR ==3 ) print $4}' output.dat`
		inlon=`awk '{if ( NR ==2 ) print $5}' output.dat`
		outlon=`awk '{if ( NR ==3 ) print $5}' output.dat`
		intime=`awk '{if ( NR ==2 ) print $3}' output.dat`
		outtime=`awk '{if ( NR ==3 ) print $3}' output.dat`

		echo $gcarc $stat $stla $stlo $evla $evlo $depth $inlat $inlon $outlat $outlon $turnlat $turnlon $turndep >> stationdetails.dat
		echo $intime $outtime >> timedetails.dat
		#echo $evla $evlo > $cmtcode.dat
	done
	rm  seisdetails.dat sacmac.m output.dat
done
