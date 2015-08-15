#!/bin/sh

youtube-dl -c -i -f 'bestvideo[height<=?480]+bestaudio/best' -o '%(title)s (%(height)sp).%(ext)s' --prefer-ffmpeg $1

#sudo youtube-dl -v -c -i -f 'bestvideo[height<=?480]+bestaudio/best' --prefer-ffmpeg $1
