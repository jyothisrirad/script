#!/bin/sh

git pull

git add .
git commit -a -m "Automated commit at $(date +"%D") $(date +"%T") on "$HOSTNAME"" 
git push
