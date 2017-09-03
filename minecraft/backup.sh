#!/bin/bash

if [ ! -d "$1" ]; then
	echo $1 is not a directory
	exit
fi

MAXBACKUP=8

# FULL=$(readlink -e $0)
# DP0=$(dirname $FULL)
DP1="$1"

. "$DP1"/config.sh

BASE=$(basename "$DP1")


backup() {

TODAY=$(date +"%Y-%m-%d_%H%M")
HOST=$(hostname)
ZIP=$BASE.$TODAY.$HOST.zip
# TEMPZIP=/tmp/$ZIP
TEMPZIP=~/$ZIP

echo -e "${GREEN}Creating $ZIPDIR/$ZIP${NC}"

IGNORE1=crash-reports/*
IGNORE2=logs/*
IGNORE3=ForgeEssentials/Backups/*

cd "$DP1"

echo zip -x "$IGNORE1" "$IGNORE2" "$IGNORE3" -r $TEMPZIP ./*
zip -x "$IGNORE1" "$IGNORE2" "$IGNORE3" -r $TEMPZIP ./*
mv $TEMPZIP $ZIPDIR

}

purge() {

echo -e "${GREEN}Purge $ZIPDIR/$BASE*.zip, Keeping latest $1 files. ${NC}"

ZIP=(`ls -at $ZIPDIR/$BASE*.zip`)

INDEXMAX=$(( ${#ZIP[@]} - 1 ))

for ((i=$1; i<=$INDEXMAX; i++)); do
	# echo -n "$i: "
	echo removing ${ZIP[$i]}
	rm ${ZIP[$i]}
done

}


backup

purge $MAXBACKUP

