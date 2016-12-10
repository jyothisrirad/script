#!/bin/sh

# for last; do true; done
# echo $last

#set -- "${@:1:$(($#-1))}"

prefix=$1
shift

youtube-dl -c -i -f 'bestvideo[height=480]+bestaudio/best' -o "$prefix/%(title)s (%(height)sp).%(ext)s" --prefer-ffmpeg --verbose $*
