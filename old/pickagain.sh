#! /bin/bash

scriptloc=/raid1/ds598/scripts

rm -r tauptraveltimecurve/
rm -r pswigascii

$scriptloc/doremoveduds.sh
$scriptloc/findtraveltimes.sh
$scriptloc/sactoascii.sh

cd pswigascii

$scriptloc/tracesepi.sh
