#!/bin/bash

# This is a script which renames files ready for stacking
# It also sactoasciis the files, and readies them for printing in an epicetral distance plot 

# Works on filenames of the type sac_norm_f_0.5_1.5_200601022213A_CI_WBS_epidist_79.2144241_dfbplat_-9.29_dfbplon_29.74_BHZ_.SAC



# Sac to ascii:
sactoascii='/raid1/ds598/bin/sactoascii'

for seis in `ls *fil`
do

	#echo "enter seismogram"
	#read seis

	echo echo on > sacmac.m
	echo rh $seis >> sacmac.m
	echo "setbb gcarc &1,gcarc&" >> sacmac.m
	echo "sc echo \" %gcarc \" > seisdetails.dat" >>sacmac.m
	echo "quit" >> sacmac.m
	/usr/local/sac/bin/sac sacmac.m
	rm -fr sacmac.m

	gcarc=`awk '{print $1}' seisdetails.dat`
	rm  seisdetails.dat

	echo $seis > test
	date=`awk -F'.' '{print $1}' test`
	name=`awk -F'.' '{print $2}' test`
	rm  test

	scp $seis ${date}.${name}_${gcarc}_BHZ.s_fil.SAC
done


for file in *.SAC
do
cat << EOF | $sactoascii
$file
EOF

	newname=`echo $file | awk -F".SAC" '{print $1}'`

	#This will produce the file data.out which I now want to rename
	echo 'Now moving files'

	mv data.out ./"$newname".out
	rm datainfo.out
done


# The script also renames files in a helpful way for plotting as sac to ascii just outputs data of the form time (column 1) and then amplitudes of seismogram (column 2)
# Therfore it is necessary to have the epicentral distance somwhere in the filename
# In the sactoascii program I call gcarc and print to screen. gcarc is the 7th thing that it prints to screen

# this script needs to run in the directory with all the data

# Files names are of the type sac_norm_f_0.5_1.5_200601022213A_CI_WBS_epidist_79.2144241_dfbplat_-9.29_dfbplon_29.74_BHZ_.out

#Set variables

mkdir ./pswigascii
echo 'Now moving files'

for file in ./*.out
do
	gcarc=`echo $file | awk -F"_" '{print $2}'`
	echo $gcarc
	cat $file | awk '{print $2 " " '$gcarc' " " $1}' > $file.pswig

	mv -f $file.pswig ./pswigascii
done

rm -fr *.SAC *.out
