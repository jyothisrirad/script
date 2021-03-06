#!/bin/bash

loop=150000
blocksize=1M

isroot() {                                                     
  if [ $(whoami) = "root" ]; then return 0; else return 1; fi  
}                                                              

diskflush() {

# free -h

echo Flushing Disk Cache
sudo sync
sudo sync
sudo sync

echo Original Setting in /proc/sys/vm/drop_caches
cat /proc/sys/vm/drop_caches

# if isroot; then 
  # echo 3 > /proc/sys/vm/drop_caches
# else 
  # echo 3 | sudo tee /proc/sys/vm/drop_caches
# fi


# And free up caches
#
echo Freeing the page cache:
# echo 1 > /proc/sys/vm/drop_caches
sudo sysctl -w vm.drop_caches=1

echo Free dentries and inodes:
# echo 2 > /proc/sys/vm/drop_caches
sudo sysctl -w vm.drop_caches=2

echo Free the page cache, dentries and the inodes:
# echo 3 > /proc/sys/vm/drop_caches
sudo sysctl -w vm.drop_caches=3

# free -h
}

benchmark() {
diskflush

# testfile=zerofile.tmp
testfile=$1
result=$(sudo dd if=/dev/zero of=$testfile bs=$blocksize count=$loop 2>&1)
sudo rm $testfile


result=$(echo $result | sed "s/dd: error writing $(echo -ne '\u2018')zerofile.tmp$(echo -ne '\u2019'): No space left on device//")
speed=$(echo $result | awk '{print $14}') 
unit=$(echo $result | awk '{print $15}') 
count=$(echo $result | awk '{print $1}') 
totalsec=$(echo $result | awk '{print $12}') 
iops=$(awk "BEGIN {print ($count)/$totalsec}")


echo $result
echo ------------------------------------
echo Write: $speed $unit
echo IOPS: $iops
}

test_suite() {
tpath=$1
echo ====================================
echo Computer: $(hostname) 
echo $(sudo zfs get compression $tpath | tail -n 1)
echo ====================================
benchmark /$tpath/zerofile.tmp
echo ====================================
benchmark /$tpath/zerofile.tmp
echo ====================================
benchmark /$tpath/zerofile.tmp
echo ====================================
}

sudo zpool status
echo Testing IOPS with 150GB, $loop of $blocksize writes
test_suite tank
test_suite tank/Shares

