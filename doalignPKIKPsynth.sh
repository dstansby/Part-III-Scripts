#!/bin/bash
#
# doalignallPKIKPall.sh
#
# Aligns PKIKP, PKiKP and both plots to a point picked from the PKiKP plot
# Run from PKiKP folder
#
# David Stansby 2015

# Set thes to the phases that need to be automatically aligned
# (ie. phases not being aligned)
align1=both
align2=PKiKP

mkdir done

for seis in *fil
do

	rm  tempmac seisdetails.dat

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
