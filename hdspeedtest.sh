#!/bin/bash

loop=150000
blocksize=1M

isroot() {                                                     
  if [ $(whoami) = "root" ]; then return 0; else return 1; fi  
}                                                              

diskflush() {
sync

if isroot; then 
  echo 3 > /proc/sys/vm/drop_caches
else 
  echo 3 | sudo tee /proc/sys/vm/drop_caches
fi

}

benchmark() {
diskflush

testfile=zerofile.tmp
result=$(dd if=/dev/zero of=$testfile bs=$blocksize count=$loop 2>&1)
rm $testfile


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

echo Flushing Disk Cache
diskflush

echo Testing IOPS with 150GB, $loop of $blocksize writes
echo ====================================
echo Computer: $(hostname)
echo ====================================
benchmark
echo ====================================
benchmark
echo ====================================
benchmark

