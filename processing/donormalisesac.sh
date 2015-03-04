for file in *fil

do

echo echo on > sacmac.m
echo rh $file >> sacmac.m
echo " sc echo &1,T2& > test" >> sacmac.m
echo quit >> sacmac.m

/usr/local/sac/bin/sac sacmac.m
rm -fr sacmac.m

start=`awk '{print $1-5}' test`
end=`awk '{print $1+5}' test`
echo $start $end
rm -fr test

echo echo on > sacmac.m
echo r $file >> sacmac.m
echo cut $start $end >> sacmac.m
echo r $file >> sacmac.m
echo " sc echo $file >> test.dat " >> sacmac.m
echo " sc echo &1,DEPMAX& &1,DEPMIN& >> test " >> sacmac.m
echo quit >> sacmac.m

/usr/local/sac/bin/sac sacmac.m
rm -fr sacmac.m

norm=`awk '{print ($1-$2)/2}' test`
echo $norm

echo echo on > sacmac.m
echo r $file >> sacmac.m
echo div $norm >> sacmac.m
echo w over >> sacmac.m
echo quit >> sacmac.m

/usr/local/sac/bin/sac sacmac.m
rm -fr sacmac.m


done
