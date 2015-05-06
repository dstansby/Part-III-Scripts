#! /bin/bash
# plotpathmap.sh
#
# This script plots, into map.ps, a map with symbols representing the
# differential travel time, bottoming point, bottoming depth
# and inner core raypaths

residlim=$1

# Define projection, and set text parameters
proj="-JR0/25 -R-180/180/-90/90"
o="-K -V -O"

# Count number of paths

# PS header and time stamp and boxes
echo 0 0  | psxy -R1/2/1/2 -JX4.25/6.25 -Sp -K > map.ps

# Make colour palete
if [ "$#" == 1 ]; then
	makecpt -Cpolar -T-$1/$1/0.1 -Z > g.cpt
else
	makecpt -Cpolar -T-1.2/1.2/0.1 -Z > g.cpt
fi

#Plot coast
pscoast  $proj -Bg45/g45:."": -Y1  -Dc -W0.0001p/210 -G220 $o >> map.ps


#Plot paths in the inner core
rm alldetails.dat
for folder in */; do
	cd $folder
	echo $folder
	cat stationdetails_ak135.dat >> ../alldetails.dat
	cd ../
done

nmax=`wc -l <  alldetails.dat`
for ((n=0; n <= $nmax ; n++))
do
        awk '{ if (NR == '$n') print $9 " " $8 " \n" $11 " " $10 }'  alldetails.dat | psxy $proj -W0.01p/50 -K -O >> map.ps
done

#Finish up
echo 0 0  | psxy -R1/2/1/2 -JX1/1 -Sp -O >> map.ps
rm g.cpt

#Open image
# gv map.ps &
