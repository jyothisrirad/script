#!/bin/sh

/usr/local/bin/youtube-dl -c -i -o 'mp3/%(title)s (%(height)sp).%(ext)s' -k -x --audio-format mp3 --audio-quality 176 --prefer-ffmpeg $*
