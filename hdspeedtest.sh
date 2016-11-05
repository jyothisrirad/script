#!/bin/bash

echo 3 | sudo tee /proc/sys/vm/drop_caches

echo Testing IOPS with 150GB, 150K of 1M writes
testfile=zerofile.tmp
result=$(dd if=/dev/zero of=$testfile bs=1M count=10 2>&1)
rm $testfile


speed=$(echo $result | awk '{print $14}') 
unit=$(echo $result | awk '{print $15}') 
count=$(echo $result | awk '{print $1}') 
totalsec=$(echo $result | awk '{print $12}') 
iops=$(awk "BEGIN {print ($count)/$totalsec}")

echo =====
echo Computer: $(hostname)
echo =====
echo $result
echo =====
echo Write: $speed $unit
echo IOPS: $iops
