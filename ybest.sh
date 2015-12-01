#!/bin/sh

for last; do true; done
echo $last

/usr/local/bin/youtube-dl -c -i -f best -o "$last%(title)s (%(height)sp).%(ext)s" --prefer-ffmpeg $*
