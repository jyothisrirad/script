#!/bin/sh

youtube-dl -c -i -f best -o 'video/%(title)s (%(height)sp).%(ext)s' --prefer-ffmpeg $1
