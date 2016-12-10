#!/bin/bash

FULL=$(readlink -e $0)
DP0=$(dirname $FULL)
. $DP0/config.sh

# ~/script/youtube/y720best.sh /vagrant/temp https://www.youtube.com/playlist?list=PLL7H7U6zd1f0df68ySccybaTThFdcQCaZ
# ~/script/youtube/y720best.sh /vagrant/temp https://www.youtube.com/watch?v=0utYSyc3uNM
# ~/script/youtube/y480best.sh /vagrant/temp https://www.youtube.com/playlist?list=PLUg6CGAXr7pmHa1uY0CztdGsqpbDs-cgZ
# ~/script/youtube/y480best.sh /vagrant/temp https://www.youtube.com/watch?v=0utYSyc3uNM


#~/script/youtube/y480best.sh /vagrant/temp https://www.youtube.com/playlist?list=PLChfvft4VNNkLY4peytV7PTy1eQ8_Vqko

~/script/youtube/y480best.sh $DSTROOT/temp --max-downloads 4 https://www.youtube.com/playlist?list=PLL7LXvkhjsoLrNMDyhYucp8A8dP8y7VIf
