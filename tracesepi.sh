#!/bin/bash
# This gmt script makes a picture of binned epicentral distances

if [ "$#" -ne 5 ]; then
	echo "Please provide z-scaling, xmin and xmax as command line arguments and run again"
	exit
fi

# Command line arguments
zscaling=$1
xminlim=$2
xmaxlim=$3
yminlim=$4
ymaxlim=$5

echo "Plotting epicentral range $yminlim to $ymaxlim"
psxydir='../tauptraveltimecurve'

# Define some colurs
PKIKPCOL='0/0/255'
PKiKPCOL='255/0/0'

o='-K -V -O'
echo 0 0 | psxy -R1/2/1/2 -JX4.25/6.25 -Sp -K -P > stations.ps

# Plot wiggles
for file in *.out.pswig
do
pswiggle ./$file -R$xminlim/$xmaxlim/$yminlim/$ymaxlim -JX7i -BWSena1f1:"Travel time (s) ":/a5f1:"Epicentral distance (deg)"::."": -Z$zscaling -W0.2p -S1500/2800/10/0.2 $o  >> stations.ps
done

# If a time travel curve exists
if [ -d "$psxydir" ]; then
	# PKIKP and PKiKP text
pstext -R -JX -O -K -N -G0/0/255 >> stations.ps <<EOF
1090 136 13 0 0 LM PKIKP
EOF

pstext -R -JX -O -K -N -G255/0/0 >> stations.ps <<EOF
1100 136 13 0 0 RM PKiKP
EOF

	# psxy theoretical travel times
	psxy $psxydir/*_PKiKP.yx -JX -R -W1p/${PKiKPCOL} $o >> stations.ps
	psxy $psxydir/*_PKIKP.yx -JX -R -W1p/${PKIKPCOL} $o >> stations.ps
fi

# Plot vertical line at t=0
psxy -L -R -JX -W1p,. -O -K -N >> stations.ps << EOF
0 $yminlim
0 $ymaxlim
EOF

echo 0 0  | psxy -R1/2/1/2 -JX1/1 -Sp -O >>  stations.ps

gv stations.ps &
