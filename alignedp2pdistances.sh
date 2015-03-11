#! /bin/bash

# Script to pick a single point and output the time to file. Point is stored in t8.

mkdir done notpicked
rm tempmac temp.dat

# Loop through each seismogram
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

	# Pick phase
echo "rh $seis
qdp off
 setbb vert $seis
 rh %vert
 chnhdr t8 undef
 chnhdr kt8 undef
 writehdr
 r %vert
 xlim -5 5
 sc echo \"Left feature t8, then press q\"
 ppk bell off
 writehdr"  >> tempmac

        echo rh $seis >> tempmac
        echo "sc echo &1,t8& > temp.dat" >> tempmac
        echo "quit" >> tempmac

        /usr/local/sac/bin/sac tempmac
        rm -fr tempmac

        # Extract picked phases
        diff=`awk '{print $1}' temp.dat`

	if [ $diff == -12345 ]; then
		echo "Not picked"
		mv $seis notpicked
	else
        	echo "$stat $gcarc $diff" >> differences.dat
		mv $seis done
	fi
done

mv done/* .
rm -r done
