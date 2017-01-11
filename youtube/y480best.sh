#!/bin/bash

# for last; do true; done
# echo $last

#set -- "${@:1:$(($#-1))}"

DP0=$(dirname $(readlink -e $0))
prefix=$1
shift

# --verbose

. $DP0/youtube-dl-retry -c -i -f 'bestvideo[height=480]+bestaudio/best' -o "$prefix/%(title)s (%(height)sp).%(ext)s" --prefer-ffmpeg --verbose $*

# until youtube-dl  -c -i -f "bestvideo[height=480]+bestaudio/best" -o "$prefix/%(title)s (%(height)sp).%(ext)s" --prefer-ffmpeg --verbose $*; do 
	# sleep 5
# done
