#! /bin/bash
# peaktopeakdistances.sh
#
# Runs through seismograms and allows user to pick two features.
# Difference in time is recorded to file
#
# David Stansby 2015
mkdir done notpicked

for seis in `ls *fil`
do
	# Get epicentral distance
	echo echo on > sacmac.m
        echo rh $seis >> sacmac.m
	echo "setbb stat &1,kstnm&" >> sacmac.m
	echo "setbb gcarc &1,gcarc&" >> sacmac.m
	echo "sc echo \" %stat  %gcarc \" > gcarc.dat" >>sacmac.m
        echo "quit" >> sacmac.m
        /usr/local/sac/bin/sac sacmac.m
        rm sacmac.m

	stat=`awk '{print $1}' gcarc.dat`
        gcarc=`awk '{print $2}' gcarc.dat`
        rm gcarc.dat

	echo $gcarc

	# Pick phases
echo "rh $seis
qdp off
 setbb vert $seis
 rh %vert
 writehdr
 r %vert
 xlim T2 -20 20
 sc echo \"Left feature t8, Right feature t9, then q\"
 ppk bell off
 writehdr"  >> tempmac

        echo rh $seis >> tempmac
        echo "sc echo &1,t8& &1,t9& > temp.dat" >> tempmac
        echo "quit" >> tempmac

        /usr/local/sac/bin/sac tempmac
        rm -fr tempmac

        # Extract picked phases
        pkikpobs=`awk '{print $1}' temp.dat`
        PKIKPobs=`awk '{print $2}' temp.dat`
        diff=`awk '{print $2-$1}' temp.dat`

	# If either feature not picked
	if [ $pkikpobs == -12345 ] || [ $PKIKPobs == -12345 ]; then
		echo "Not picked"
		mv $seis notpicked
	else
        	echo "$stat $gcarc $diff" >> peakdifferences.dat
		mv $seis done
	fi
done

mv done/* .
rm -r done
