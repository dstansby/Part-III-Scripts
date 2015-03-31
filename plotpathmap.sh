#! /bin/bash
# plotpathmap.sh
#
# This script plots, into map.ps, a map with symbols representing the
# differential travel time, bottoming point, bottoming depth
# and inner core raypaths

#Define projection, and set text parameters
proj="-JR0/25 -R-180/180/-90/90"
o="-K -V -O"

#Count number of paths
nmax=`wc -l <  stationdetails_ak135.dat`

#PS header and time stamp and boxes
echo 0 0  | psxy -R1/2/1/2 -JX4.25/6.25 -Sp -K > map.ps

#Make colour palete
if [ "$#" == 1 ]; then
	makecpt -Cpolar -T-$1/$1/0.1 -Z > g.cpt
else
	makecpt -Cpolar -T-1.2/1.2/0.1 -Z > g.cpt
fi

#Plot coast
pscoast  $proj -Bg45/g45:."": -Y1  -Dc -W0.0001p/210 -G220 $o >> map.ps

#Plot paths in the inner core
for ((n=0; n <= $nmax ; n++))
do
        awk '{ if (NR == '$n') print $9 " " $8 " \n" $11 " " $10 }'  stationdetails_ak135.dat  | psxy $proj -W0.01p/50 -K -O >> map.ps
done

#If residual data is available, plot residuals at bottoming points
if [ -f filt/differences.dat ] && [ -f wkbj/PKiKP/filt/differences.dat ]; then
	paste -d " " stationdetails.dat filt/differences.dat wkbj/PKiKP/filt/differences.dat > temp.dat

	#Plot bottoming points
	awk '{ print $13, $12, $19-$22, 0.2,"c" }' temp.dat | psxy $proj  -Cg.cpt -S $o >> map.ps

	#Plot scale + key
	psscale -Cg.cpt -D12c/-0.5c/8c/0.6ch -X0.36 -B0.5:"Differential travel time residuals (s)": $o >>map.ps
	rm temp.dat
fi

#Finish up
echo 0 0  | psxy -R1/2/1/2 -JX1/1 -Sp -O >> map.ps
rm g.cpt

#Open image
gv map.ps &
