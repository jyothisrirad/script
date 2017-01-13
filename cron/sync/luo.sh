#!/bin/bash

FULL=$(readlink -e $0)
DP0=$(dirname $FULL)
. $DP0/config.sh


echo ~/script/youtube/y480best.sh $DSTROOT/luo/ --max-downloads 1 https://www.youtube.com/user/logictalkshow/videos 

~/script/youtube/y480best.sh $DSTROOT/luo/ --max-downloads 1 https://www.youtube.com/user/logictalkshow/videos 
