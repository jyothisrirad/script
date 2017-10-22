#!/bin/bash

if [ ! -d "$1" ]; then
	echo $1 is not a directory
	exit
fi

FULL=$(readlink -e $0)
DP0=$(dirname $FULL)
DP1="$1"

. $DP1/config.sh

restore() {

BASE=$(basename $DP1)
ZIPLIST=(`ls -at $ZIPDIR/$BASE*.zip`)

cnt=0
for zip in ${ZIPLIST[@]}
do
	echo $cnt: $zip
	cnt=$((cnt + 1))
done

INDEXMAX=$(( ${#ZIPLIST[@]} - 1 ))

if (( $1 > $INDEXMAX )); then index=$INDEXMAX; else index=$1; fi

# ZIPFILE=$(ls -at $ZIPDIR/$BASE*.zip|head -1)
ZIPFILE=${ZIPLIST[$index]}

echo -e "${GREEN}Restore from $ZIPFILE${NC}"

IGNORE=logs*

unzip -o $ZIPFILE -x "$IGNORE" -d $DP1 >/dev/null

}

if [ -z ${2+x} ]; then index=0; else index=$2; fi

restore $index

