#!/bin/sh

# for last; do true; done
# echo $last

prefix=$1
shift

youtube-dl -c -i -f 'mp4[height=480]+worst/best' -o "$prefix/%(title)s (%(height)sp).%(ext)s" --prefer-ffmpeg $*
