#!/bin/bash

mkdir done notpicked
#echo "stationID PKIKP PKiKP diff gcarc zeta" > PKIKPPKiKParrivaltimes.dat

for seis in `ls *_fil`
do
echo "$seis"
	datstr=`awk '{if (NR == 1) print $0}' stationdetails.dat `
	gcarc=`awk '{if (NR == 2) print $0}' stationdetails.dat `
	zeta=`awk '{if (NR == 3) print $0}' stationdetails.dat `
echo $0
echo $datstr
echo $gcarc

# Pick phases
echo "rh $seis
qdp off
 setbb vert $seis
 rh %vert
 writehdr
 r %vert
 xlim T2 -10 T2 +10
 sc echo \"PKIKP t8, PKiKP t9, then press q\"
 ppk bell off
 chnhdr kt8 PKIKPhp
 chnhdr kt9 PKiKPhp
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

	# If data hasn't been picked
	if [ "$pkikpobs" == "-12345" ] || [ "$PKIKPobs" == "-12345" ]; then
		echo "One or more phase not picked"
		mv $seis notpicked
	else
		# Write data to file
		echo "$seis $PKIKPobs $pkikpobs $diff $gcarc $zeta"  >> PKIKPPKiKParrivaltimes.dat
		mv $seis done
	fi
done

mv done/*fil ./
rm -fr done
