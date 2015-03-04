#! /bin/bash

mkdir done notpicked
#rm differnces.dat
#echo "EpiDistance deltaT" > differences.dat

for seis in `ls *fil`
do
	# Epicentral distance
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
 xlim -5 5
 sc echo \"Left upswing t8, then press q\"
 ppk bell off
 writehdr"  >> tempmac

        echo rh $seis >> tempmac
        echo "sc echo &1,t8& > temp.dat" >> tempmac
        echo "quit" >> tempmac

        /usr/local/sac/bin/sac tempmac
        rm -fr tempmac

        # Extract picked phases
        PKIKPobs=`awk '{print $1}' temp.dat`
        diff=`awk '{print -$1}' temp.dat`

	if [ $PKIKPobs == -12345 ]; then
		echo "Not picked"
		mv $seis notpicked
	else
        	echo "$stat $gcarc $diff" >> differences.dat
		mv $seis done
	fi
done

mv done/* .
rm -r done
