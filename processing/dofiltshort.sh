echo "/usr/local/sac/bin/sac << %" > doit
for i
do
echo "    read" $i >> doit 
echo "    bp bu co 0.7 2 n 2 p 2" >> doit
#echo "    ch allt -26 " >> doit 
echo "    write append _fil" >> doit
done

echo "quit" >> doit
echo "%" >> doit
sh doit
rm doit
