#!/bin/sh

# for last; do true; done
# echo $last

prefix=$1
shift

/usr/local/bin/youtube-dl -c -i -o "$prefix/%(title)s (%(height)sp).%(ext)s" -k -x --audio-format mp3 --audio-quality 176 --prefer-ffmpeg $*
