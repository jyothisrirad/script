#!/bin/sh

youtube-dl -c -i -f 'bestvideo[height=480]+bestaudio/best' -o 'video/%(title)s (%(height)sp).%(ext)s' --prefer-ffmpeg $*
