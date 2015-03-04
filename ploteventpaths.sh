#! /bin/bash

filename=eventpathmap.ps

#DEFINE PROJECTION, and set text parameters
proj="-JR0/20 -R-180/180/-90/90"
o="-K -V -O"

#count the number of paths
nmax=`wc -l <  seisdetails.dat`

# write PS header and time stamp and boxes
echo 0 0  | psxy -R1/2/1/2 -JX4.25/10 -Sp -K > $filename

#plot the coast
pscoast  $proj -Bg45/g45:."": -Y1  -Dc -W0.0001p/210 -G220 $o >> $filename

awk '{print $3, $2}' seisdetails.dat | psxy $proj -Sa0.3 -G255/0/0 -K -O >> $filename
awk '{print $5, $4}' seisdetails.dat | psxy $proj -St0.3 -G0/0/255 -K -O >> $filename

#plot paths in the inner core
for ((n=0; n <= $nmax ; n++)) 
  do
  awk '{ if (NR == '$n') printf $3" " $2"  \n" $5 " " $4 }'  stationdetails.dat |  psxy  $proj -L -W0.01p/50 -K -O  >> $filename
done

#finish up
echo 0 0  | psxy -R1/2/1/2 -JX1/1 -Sp -O >> $filename

# Open image
gv $filename &
