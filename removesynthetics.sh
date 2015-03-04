#! /bin/bash
mkdir keep
mkdir norealdata

for i in *.wkbj_fil
do
	file=${i:10:4}
	echo $file

	if [ -e ../../../filt/*"$file"* ]; then
		mv $i keep
	else
		echo "Removing"
		mv $i norealdata
	fi
done

mv keep/* .
rm -r keep
