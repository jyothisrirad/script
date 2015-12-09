#!/bin/sh

for last; do true; done
echo $last

#set -- "${@:1:$(($#-1))}"

/usr/local/bin/youtube-dl -c -i -f 'bestvideo[height=480]+bestaudio/best' -o "$last%(title)s (%(height)sp).%(ext)s" --prefer-ffmpeg --verbose $*
