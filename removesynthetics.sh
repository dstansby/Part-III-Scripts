#! /bin/bash
# removesynthetics.sh
#
# Moves synthetics to ./norealdata if there isn't a corresponding real sesimogram
#
# David Stansby 2015

mkdir keep norealdata

for seis in *.wkbj_fil
do
	#Extract characters 10-15
	file=${seis:10:5}
	echo $file

	if [ -e ../../../filt/*"$file"* ]; then
		mv $seis keep
	else
		echo "Removing"
		mv $seis norealdata
	fi
done

mv keep/* .
rm -r keep
