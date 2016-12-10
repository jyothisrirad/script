#!/bin/bash

FULL=$(readlink -e $0)
DP0=$(dirname $FULL)
. $DP0/config.sh

~/script/youtube/y720best.sh $DSTROOT/yoz https://www.youtube.com/playlist?list=PLjNwYpNvYICoSFaytXX-DCoJ-sW8FGCFc
