#!/bin/sh

echo killing off $1 ...
#kill -9 $(ps aux | grep '$1' | awk '{print $2}')
kill -9 $(pidof $1)
