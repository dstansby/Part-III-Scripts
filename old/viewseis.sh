#! /bin/bash

for file in *_fil
do
echo echo on > tempmac
echo "r $file
 xlim t1 -10 10
 ppk
 quit" >> tempmac

	/usr/local/sac/bin/sac tempmac
	rm -f tempmac
done
