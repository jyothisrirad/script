#!/bin/bash

FULL=$(readlink -e $0)
DP0=$(dirname $FULL)
. $DP0/config.sh


# ~/script/youtube/y480best.sh /vagrant/lang/ --max-downloads 1 https://www.youtube.com/playlist?list=PLJsCOCslPUGf-pZvsEuDFreS-OOojqmg5 
~/script/youtube/y480best.sh $DSTROOT/lang/ --max-downloads 1 https://www.youtube.com/playlist?list=PL3QR-DYngFrhEbT_hQBDx-mPXTRK_paOu
