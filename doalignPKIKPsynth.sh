#!/bin/bash
#
# doalignallPKIKPall.sh
#
# Aligns PKIKP, PKiKP and both plots to a point picked from the PKiKP plot
# Run from PKiKP folder
#
# David Stansby 2015

# Set these to the phases that need to be automatically aligned
# (ie. phases not being aligned)
align1=both
align2=PKiKP

minangle=$1
maxangle=$2

# If only one command line argument
if [ "$#" == "1" ]; then
        echo "Please provide both a minimum and maximum angle as command line arguments"
        exit
fi

# If more than two command line arguments
if [ "$#" -gt "3" ]; then
        echo "Too many arguments, try again with minimum and maximum angle"
fi

rm tempmac seisdetails.dat
mkdir done

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
        rm seisdetails.dat

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
                rm tempmac seisdetails.dat
        fi

	# Pick phase (stored in t6)
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
	rm tempmac
	time=`awk '{print $1}' seisdetails.dat`

	for file in $seis ../../$align1/filt/$seis ../../$align2/filt/$seis
	do
		# Change time in header files
		echo echo on > tempmac
		echo r $file >> tempmac

		# If offset is less than zero, add the difference, else subtract
		isnegative='-*'
		if [[ $time = $isnegative ]]; then
		        time2=`echo -n $time | cut -c2-`
		        echo "ch ALLT $time2 IZTYPE IO" >> tempmac
		else
		        echo "ch ALLT -$time IZTYPE IO" >> tempmac
		fi

		echo "w over" >> tempmac
		echo "quit" >> tempmac

		/usr/local/sac/bin/sac tempmac
		rm tempmac
	done

	rm -fr seisdetails.dat
	echo "Done!"
	mv $seis done
done

mv done/* .
rm -r done
