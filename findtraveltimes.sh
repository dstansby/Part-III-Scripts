#!/bin/bash
#
# This is a now fairly general script that runs taup_time for a range of epicentral distances and sticks it an output file
#
# Note that it does not consider the ellipticity of the Earth

rm -fr tauptraveltimecurve sacmac.m test.dat

ls *fil > test
one=`awk 'NR==1 {print $1}' test`
rm -fr test

echo echo on > sacmac.m
echo "r $one" >> sacmac.m
echo "setbb evdp &1,evdp&" >> sacmac.m
echo "sc echo \" %evdp \" >> test.dat" >> sacmac.m
echo quit >> sacmac.m
/usr/local/sac/bin/sac sacmac.m
rm -fr sacmac.m
depth=`awk '{print $1/1000}' test.dat`
rm -fr test.dat

for file in *fil
do
	echo echo on > sacmac.m
	echo rh $file >> sacmac.m
	echo "setbb gcarc &1,gcarc&" >> sacmac.m
	echo "sc echo \" %gcarc \" >> gcarc.dat" >>sacmac.m
	echo "quit" >> sacmac.m
	/usr/local/sac/bin/sac sacmac.m
	rm -fr sacmac.m
done

sort gcarc.dat > gcarc2.dat
mingcarc=`awk 'NR==1 {print $1-5}' gcarc2.dat`
maxgcarc=`awk 'END{print $1+5}' gcarc2.dat`
rm -fr gcarc.dat gcarc2.dat

model=ak135
#echo "Minimum epicentral distance (-0.1 degrees), in degrees (multiple of 0.1 degrees)"

deltagcarc=`echo $maxgcarc-$mingcarc | bc -l`
stepsize='0.1'
steps=`echo $deltagcarc/$stepsize | bc`

# Move files as we go
mkdir tauptraveltimecurve
taup_curve -pf /raid1/ds598/scripts/phasefile.txt -h ${depth} -mod ${model} -o ${model}_${depth}_all.xy
mv ${model}_${depth}_all.xy.gmt ${model}_${depth}_all.txt
mv ${model}_${depth}_all.txt ./tauptraveltimecurve

for phase in PKiKP PKIKP
do
	echo $phase
	taup_curve -ph ${phase} -h ${depth} -mod ${model} -o ${model}_${depth}_${phase}.xy
	#cat ${model}_${depth}_${phase}.xy | awk
	mv ${model}_${depth}_${phase}.xy.gmt ./tauptraveltimecurve/${model}_${depth}_${phase}.xy
done

cd tauptraveltimecurve

for file in *.xy
do
	cat $file | awk '{ if (NR != 1) print $2 " " $1 }' >temp.out
	newname=`echo $file | awk -F".xy" '{print $1}'`
	mv temp.out ${newname}.yx
done

cd ../
