#! /bin/bash
rm -fr sacmac.m stationdetails.dat seisdetails.dat output.dat

for file in *_fil
do

echo echo on > sacmac.m
echo rh $file >> sacmac.m
echo "setbb stat &1,kstnm&" >> sacmac.m
echo "setbb stla &1,stla&" >> sacmac.m
echo "setbb stlo &1,stlo&" >> sacmac.m
echo "setbb evla &1,evla&" >> sacmac.m
echo "setbb evlo &1,evlo&" >> sacmac.m
echo "sc echo \" %stat %evla %evlo %stla %stlo \" >> stationdetails.dat" >>sacmac.m
echo "quit" >> sacmac.m


/usr/local/sac/bin/sac sacmac.m
rm -fr sacmac.m

done
