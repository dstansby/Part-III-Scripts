#! /bin/bash
rm -fr sacmac.m gcarc.dat

for file in *fil

do
	#echo "enter seismogram"
	#read seis

	echo echo on > sacmac.m
	echo rh $file >> sacmac.m
	echo "setbb gcarc &1,gcarc&" >> sacmac.m
	echo "sc echo $file \" %gcarc \" >> gcarc.dat" >> sacmac.m
	echo "quit" >> sacmac.m

	/usr/local/sac/bin/sac sacmac.m
	rm -fr sacmac.m
done
