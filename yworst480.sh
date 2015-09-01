#!/bin/sh

youtube-dl -c -i -f 'mp4[height=480]+worst/best' -o 'video/%(title)s (%(height)sp).%(ext)s' --prefer-ffmpeg $*
