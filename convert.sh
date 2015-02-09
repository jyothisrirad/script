#!/bin/sh

iconv "$1" -f gb2312 -t big5 -o "temp-$1"
iconv "temp-$1" -f big5 -t utf8 -o "$1"
rm "temp-$1"
