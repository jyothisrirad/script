#!/bin/sh

for last; do true; done
echo $last

/usr/local/bin/youtube-dl -c -i -o "$last%(title)s (%(height)sp).%(ext)s" -k -x --audio-format mp3 --audio-quality 176 --prefer-ffmpeg $*
