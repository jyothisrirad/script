#!/bin/bash

FULL=$(readlink -e $0)
DP0=$(dirname $FULL)
. $DP0/config.sh

~/script/youtube/ymp3.sh $DSTROOT/jenny/ https://www.youtube.com/playlist?list=PLqbfraq6ndW64vwaOpzu1oCf6lyPjOdrh 

#~/script/youtube/ymp3.sh $DSTROOT/jenny/ --max-downloads 1 https://www.youtube.com/playlist?list=PLqbfraq6ndW64vwaOpzu1oCf6lyPjOdrh 
