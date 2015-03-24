#!/bin/bash

# Automates wkbj synthetic processing
# - Run from the to directory of the specific quake
# - Ends after populating all the time headers, ready for data to be aligned
# - Takes earth model to be used as command line input
#
# David Stansby 2015

if [ "$#" -ne 1 ]; then
	echo "Please provide earth model and run again"
	exit
fi

earthModel=$1

scriptdir=/raid1/ds598/scripts
quakedir=`pwd`
wkbjdir=/raid1/ds598/wkbjAutomator
mkdir $earthModel

# Clean up the wkbj directory
cd $wkbjdir
./cleanup.sh

# Prepare wkbjAutomator
cd $quakedir/filt
$scriptdir/wkbj/preparewkbjautomatorbasic.sh

# Run wkbjAutomator
cd /raid1/ds598/wkbjAutomator
$scriptdir/wkbj/doall.sh $earthModel

# Move generated plots out of wkbjAutomator directory
cd OUTPUT
for dir in * ; do
	mv $dir/* $quakedir/$earthModel/
done

cd $quakedir/$earthModel
for dir in * ; do
	cd $dir/filt
	$scriptdir/processing/timeheaderpopulate.sh
	$scriptdir/sactoascii.sh
	cd pswigascii
	$scriptdir/tracesepi.sh 0.000002 1050 1200 115 135
	cd $quakedir/$earthModel
done
