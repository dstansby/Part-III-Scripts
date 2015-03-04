#! /bin/bash
# This script plots, into map.ps, a map with symbols representing the
# differential travel time, bottoming point, bottoming depth
# and inner core raypaths

#DEFINE PROJECTION, and set text parameters
proj="-JR0/25 -R-180/180/-90/90"
o="-K -V -O"

#count the number of paths
nmax=`wc -l <  stationdetails.dat`

# write PS header and time stamp and boxes
echo 0 0  | psxy -R1/2/1/2 -JX4.25/6.25 -Sp -K > map.ps

#make the colour palete
makecpt -Cpolar -T-1.2/1.2/0.1 -Z > g.cpt

#Plot the coast
pscoast  $proj -Bg45/g45:."": -Y1  -Dc -W0.0001p/210 -G220 $o >> map.ps

# Put together path/station details and residual details
paste -d " " stationdetails.dat filt/differences.dat wkbj/both/filt/differences.dat > temp.dat

#Plot paths in the inner core
for ((n=0; n <= $nmax ; n++))
do
        awk '{ if (NR == '$n') print $9 " " $8 " \n" $11 " " $10 }'  temp.dat  | psxy $proj -W0.01p/50 -K -O >> map.ps
done

#Plot bottoming points
awk '{ print $13, $12, $17-$20, 0.2,"c" }' temp.dat | psxy $proj  -Cg.cpt -S $o >> map.ps

#Plot scale + key
psscale -Cg.cpt -D12c/-0.5c/8c/0.6ch -X0.36 -B0.5:"Differential travel time residuals (s)": $o >>map.ps

#Finish up
echo 0 0  | psxy -R1/2/1/2 -JX1/1 -Sp -O >> map.ps
rm temp.dat g.cpt

#Open image
gv map.ps &
