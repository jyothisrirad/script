#!/bin/bash

if [ ! -d "$1" ]; then
	echo $1 is not a directory, mkdir it.
	# exit
	mkdir "$1"
fi

FULL=$(readlink -e $0)
DP0=$(dirname $FULL)
DP1="$1"

ZIPDIR=/mnt/backup
[ ! -f $DP1/config.sh ] || . $DP1/config.sh
. /home/sita/script/include/console.color

BASE=$(basename $DP1)
ZIPDIR=$(echo $ZIPDIR/$BASE)


listfile() {
	# ZIPLIST=(`ls -at $ZIPDIR/${BASE:0:5}*.zip`)
	ZIPLIST=(`ls -at $ZIPDIR/*.zip`)

	echo -e "${GREEN}===== Content of $ZIPDIR =====${NC}"

	cnt=0
	for zip in ${ZIPLIST[@]}
	do
		echo $cnt: $(basename $zip)
		cnt=$((cnt + 1))
	done

	echo -e "${GREEN}=====${NC}"
}

restore() {

	# ZIPLIST=(`ls -at $ZIPDIR/${BASE:0:5}*.zip`)
	ZIPLIST=(`ls -at $ZIPDIR/*.zip`)

	INDEXMAX=$(( ${#ZIPLIST[@]} - 1 ))

	if (( $1 > $INDEXMAX )); then index=$INDEXMAX; else index=$1; fi

	# ZIPFILE=$(ls -at $ZIPDIR/$BASE*.zip|head -1)
	ZIPFILE=${ZIPLIST[$index]}

	echo -e "${GREEN}Restore from $ZIPFILE${NC}"

	IGNORE=logs*

	unzip -o $ZIPFILE -x "$IGNORE" -d $DP1 >/dev/null

}

if [ "$2" = '?' ]; then 
	listfile
else
	if [ -z ${2+x} ]; then index=0; else index=$2; fi

	restore $index
fi
