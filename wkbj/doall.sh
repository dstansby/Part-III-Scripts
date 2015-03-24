#! /bin/bash
#
# Runs wkbj and produces synthetics

echo "Starting doall.sh"

if [ "$#" -ne 1 ]; then
	echo "Please provide earth model and run again"
	exit
fi

earthModel=$1

WKBJAUTOMATOR_LIB=/raid1/ds598/wkbjAutomator
export WKBJAUTOMATOR_LIB

if [ ! -d OUTPUT ]; then
mkdir OUTPUT; fi

if [ ! -d done ]; then
mkdir done; fi

for file in `ls events`
do
	filetrunc=`echo $file | cut -d '_' -f 1`

	echo "$file is here"
	echo $file > file.dat


	cmtcode=`awk -F"." '{print $1}' file.dat`
	location=`awk -F"." '{print $2}' file.dat`


	X=${cmtcode:0:1}
	Y=${cmtcode:4:1}
	if test "$X" -eq "2"
	then
		date="${cmtcode:6:2},${cmtcode:4:2},${cmtcode:0:4}"
	else
		if test "$X" -eq "1"
		then
			date="${cmtcode:6:2},${cmtcode:4:2},${cmtcode:0:4}"
		else
			if test "$Y" -eq "0"
			then
				date="${cmtcode:2:2},${cmtcode:0:2},20${cmtcode:4:2}"
			else
				date="${cmtcode:2:2},${cmtcode:0:2},19${cmtcode:4:2}"
			fi
		fi
	fi

	depth=`awk '{print $0*10}' depths/$filetrunc.depth`
	depth1=`awk '{print $0}' depths/$filetrunc.depth`
	if test "$depth" -lt "200"
	then
		layer="1"
		depthrange="0-20km"
	else
	if test "$depth" -ge "200" && test "$depth" -lt "350"
	then
		layer="2"
		depthrange="20-35km"
	else
	if test "$depth" -ge "350" && test "$depth" -lt "2100"
	then
		layer="3"
		depthrange="35-210km"
	else
	if test "$depth" -ge "2100" && test "$depth" -lt "4100"
	then
		layer="4"
		depthrange="210-410km"
	else
	if test "$depth" -ge "4100" && test "$depth" -lt "6600"
	then
		layer="5"
		depthrange="410-660km"
	else
		layer="6"
		depthrange="deeper than 660km"
	fi
	fi
	fi
	fi
	fi

	echo depth is $depth1, therefore layer is $layer, $depthrange
	echo $depth1 > depth.dat

	eventinfo=`awk '(NR==1) {print $0}' eventinfo/$filetrunc.dat`
	echo $eventinfo > eventinfo.dat

	time=`awk '{print $0}' times/$filetrunc.time`
	echo CMT event time is probably $time
	echo  

	mkdir $cmtcode.$location

	for phases in PKIKP$layer PKiKP$layer PKIKP$layer,PKiKP$layer
	do
		./wkbjAutomatorL -v -e $earthModel.$layer -r $phases -d $date -s `awk '{print $0}' events/$cmtcode.$location`

		for fname in `ls *.wkbj`
			do
			echo $fname > fname.dat
			name=`awk -F"." '{print $1}' fname.dat`
			mv $fname ${cmtcode}.${name}.BHZ.wkbj
		done

		depthsac=`awk '{print $1*1000}' depth.dat`
		echo echo on > sacmac.m
		echo r *BHZ.wkbj >> sacmac.m
		echo ch evdp $depthsac >> sacmac.m
		echo w over >> sacmac.m
		echo quit >> sacmac.m
		/usr/local/sac/bin/sac sacmac.m

		if [ $phases == "PKIKP$layer" ]; then
			dir=PKIKP
		elif [ $phases == "PKiKP$layer" ]; then
			dir=PKiKP
		else
			dir=both
		fi

		mkdir $cmtcode.$location/$dir
		mv *wkbj $cmtcode.$location/$dir
		mkdir $cmtcode.$location/$dir/orig
		mkdir $cmtcode.$location/$dir/filt
		mv $cmtcode.$location/$dir/*wkbj $cmtcode.$location/$dir/orig
		/raid1/ds598/scripts/processing/dofiltshort.sh $cmtcode.$location/$dir/orig/*wkbj
		mv $cmtcode.$location/$dir/orig/*fil $cmtcode.$location/$dir/filt

	done
	mv $cmtcode.$location OUTPUT

	rm sacmac.m depth.dat
	mv events/$file done
	rm eventinfo.dat depth.dat file.dat
done
