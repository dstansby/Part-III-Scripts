#!/bin/bash

# doremoveduds.sh
#
# Runs through seismograms, and allows user to choose whether to keep or remove them
#
# David Stansby 2015

mkdir remove keep

for seis in ` ls *_fil`
do

echo "rh $seis
qdp off
 setbb vert $seis
 rh %vert
  chnhdr kt9 undef
  chnhdr t9 undef
 writehdr
 r %vert
 xlim T1 -20 T2 +20
 sc echo \"To keep, t9 then q. To bin just q\"
 ppk bell off
 chnhdr kt9 keep
 writehdr"  > tempmac
	echo rh $seis >> tempmac
	echo "sc echo &1,t9& > temp.dat" >> tempmac
	echo "quit" >> tempmac

	/usr/local/sac/bin/sac tempmac
	rm -fr tempmac

	tempobs=`awk '{print $1}' temp.dat`
	rm -fr temp.dat

	if [ "$tempobs" == "-12345" ]; then
		mv $seis remove
	else
		mv $seis keep
	fi
done

mv keep/*fil ./
rm -r keep

# Remove picked time from header files
echo "echo on" > tempmac
echo "rh *fil" > tempmac
echo "chnhdr kt9 undef"  >> tempmac
echo "chnhdr t9 undef"  >> tempmac
echo "writehdr"  >> tempmac
echo "quit" >> tempmac
/usr/local/sac/bin/sac tempmac
rm tempmac
