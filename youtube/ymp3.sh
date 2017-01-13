#!/bin/sh

# for last; do true; done
# echo $last

prefix=$1
shift

# -k
youtube-dl -c -i -o "$prefix/%(title)s (%(height)sp).%(ext)s" -x --audio-format mp3 --audio-quality 176 --prefer-ffmpeg $*
