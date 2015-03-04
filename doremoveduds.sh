#!/bin/bash  

mkdir remove keep

for seis in ` ls *_fil`

do

rm -fr tempmac tempmac1 testc.dat testi.dat tc.dat ti.dat

echo "rh $seis
qdp off
 setbb vert $seis
 rh %vert
  chnhdr kt9 undef
  chnhdr t9 undef
 writehdr
 r %vert
 xlim T1 -20 T2 +20
 sc echo \"to keep, enter t9 then press q. To bin just press q\"
 ppk bell off
 chnhdr kt9 keep
 writehdr"  >> tempmac
echo rh $seis >> tempmac
echo "sc echo &1,t9& > temp.dat" >> tempmac
echo "quit" >> tempmac

/usr/local/sac/bin/sac tempmac
rm -fr tempmac

tempobs=`awk '{print $1}' temp.dat`
rm -fr temp.dat

if [ "$tempobs" == "-12345" ]
then
mv $seis remove
else
mv $seis keep
fi

done

mv keep/*fil ./
rm -fr keep

echo "echo on" > tempmac
echo "rh *fil" > tempmac
echo "chnhdr kt9 undef"  >> tempmac
echo "chnhdr t9 undef"  >> tempmac
echo "writehdr"  >> tempmac
echo "quit" >> tempmac
/usr/local/sac/bin/sac tempmac
rm -fr tempmac
