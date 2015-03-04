#!/bin/bash
#
# doalignallPKIKPreal.sh
# Aligns real seismogram data to picked PKiKP point
# Run from a folder with filtered data
#
# David Stansby 2015
mkdir done remove

if [ "$#" == "1" ]; then
        echo "Please provide both a minimum and maximum angle as command line arguments"
        exit
fi
if [ "$#" -ge "3" ]; then
	echo "Too many arguments, try again with minimum and maximum angle"
fi

minangle=$1
maxangle=$2

for seis in *fil
do
	# Extract epicentral distance
       	#echo echo on > sacmac.m
       	echo rh $seis > sacmac.m
       	echo "setbb gcarc &1,gcarc&" >> sacmac.m
       	echo "sc echo \" %gcarc \" > seisdetails.dat" >>sacmac.m
       	echo "quit" >> sacmac.m

       	/usr/local/sac/bin/sac sacmac.m
       	rm -fr sacmac.m
       	gcarc=`awk '{print $1}' seisdetails.dat`
       	rm -fr seisdetails.dat

       	# Extract first three digits of angle
       	gcarc=${gcarc:0:3}
	echo $gcarc

	# If range of distances is specified
	if [ "$#" == "2" ]; then

        	# Only process files within given range
        	if [ $gcarc -lt $minangle ]; then
        	        continue
        	fi
        	if [ $gcarc -gt $maxangle ]; then
        	        continue
        	fi
		rm -f tempmac seisdetails.dat
	fi
echo echo on > tempmac
echo "rh $seis
 qdp off
 setbb vert $seis
 rh %vert
 chnhdr t6 undef
 writehdr
 r %vert
 xlim t1 -20 +20
 sc echo \"t6\"
 vspace full
 ppk bell off
 writehdr"  >> tempmac
	echo "sc echo &1,t6& > seisdetails.dat" >> tempmac
	echo quit >> tempmac

	/usr/local/sac/bin/sac tempmac
	rm -f tempmac
	time=`awk '{print $1}' seisdetails.dat`

	if [ "$time" == "-12345" ]; then
		mv $seis remove
	else
		# Change time in header files
		echo echo on > tempmac
		echo r $seis >> tempmac

		# If offset is less than zero, add the difference, else subtract
		isnegative='-*'
		if [[ $time = $isnegative ]]; then
		        time=`echo -n $time | cut -c2-`
		        echo "ch ALLT $time IZTYPE IO" >> tempmac
		else
		        echo "ch ALLT -$time IZTYPE IO" >> tempmac
		fi

		echo "w over" >> tempmac
		echo "quit" >> tempmac

		/usr/local/sac/bin/sac tempmac
		rm tempmac

		rm -fr seisdetails.dat
		echo "Done!"
		mv $seis done
	fi
done

mv done/* .
rm -fr done
