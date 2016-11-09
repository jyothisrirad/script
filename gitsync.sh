#!/bin/sh

DP0=$(dirname $0)

$DP0/gitconf.sh

git pull

git add .
git commit -a -m "Automated commit at $(date +"%D") $(date +"%T") on $(hostname)" 
git push
