#!/bin/bash

# DP0=$(dirname $(readlink -e $0))
height=480

# --verbose

until youtube-dl -c -i -f "bestvideo[height=$height]+bestaudio/best" -o "./%(title)s (%(height)sp).%(ext)s" --prefer-ffmpeg --download-archive archive.txt "$1"; do 
	sleep 5
done
