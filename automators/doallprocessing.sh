#! /bin/bash

scriptloc=/raid1/ds598/scripts

echo 'Running dountar.sh'
$scriptloc/processing/dountar.sh
for dir in */ ; do

	cd $dir/orig

	echo 'Running dodates.sh'
	$scriptloc/processing/dodates.sh
	echo 'Now change event depth and location'
	sac

	echo 'Running dofiltshort.sh'
	$scriptloc/processing/dofiltshort.sh *.s
	mkdir ../filt
	mv *_fil ../filt/
	cd ../filt

	echo 'Running timeheaderpopulate.sh'
	$scriptloc/processing/timeheaderpopulate.sh

	echo 'Running doremoveduds.sh'
	$scriptloc/doremoveduds.sh

	echo 'Running findtraveltimes.sh'
	$scriptloc/findtraveltimes.sh

	echo 'Running donormalisesac.sh'
	$scriptloc/donormalisesac.sh

	echo 'Running sactoascii.sh'
	$scriptloc/sactoascii.sh

	cd pswigascii
	echo 'Running tracesepi.sh'
	$scriptloc/tracesepi.sh 2 1000 1200

	cd ../../
done
