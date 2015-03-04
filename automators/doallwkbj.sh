#!/bin/bash

# Automates wkbj synthetic processing
# - Run from the to directory of the specific quake
# - Ends after populating all the time headers, ready for data to be aligned
#
# David Stansby 2015

scriptdir=/raid1/ds598/scripts
quakedir=`pwd`
mkdir wkbj

cd filt
$scriptdir/wkbj/preparewkbjautomatorbasic.sh

cd /raid1/ds598/wkbjAutomator
./doall.sh

# Move generated plots out of wkbjAutomator directory
cd OUTPUT
for dir in * ; do
	cp -r $dir/* $quakedir/wkbj/
done
rm -r /raid1/ds598/wkbjAutomator/OUTPUT/*

cd $quakedir/wkbj
for dir in * ; do
	cd $dir/filt
	$scriptdir/processing/timeheaderpopulate.sh
	$scriptdir/sactoascii.sh
	cd pswigascii
	$scriptdir/tracesepi.sh 0.000001 1000 1200 115 135
	cd $quakedir/wkbj
done
