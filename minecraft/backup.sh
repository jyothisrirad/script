#!/bin/bash

if [ ! -d "$1" ]; then
	echo $1 is not a directory
	exit
fi

# MAXBACKUP=8
[ ! $2 ] || MAXBACKUP=$2

# FULL=$(readlink -e $0)
# DP0=$(dirname $FULL)
DP1="$1"

. "$DP1"/config.sh
. /home/sita/script/include/console.color

BASE=$(basename "$DP1")


backup() {

TODAY=$(date +"%Y-%m-%d_%H%M")
HOST=$(hostname)
ZIPDIR=$(echo $ZIPDIR/$BASE)
ZIP=$BASE.$TODAY.$HOST.zip
[ ! -z "$ZIPTAIL" ] && ZIP=$BASE.$TODAY.$HOST.$ZIPTAIL.zip
# TEMPZIP=/tmp/$ZIP
TEMPZIP=~/$ZIP

echo -e "${GREEN}Creating $ZIPDIR/$ZIP${NC}"

cd "$DP1"

# IGNORE1=crash-reports/*
# IGNORE2=logs/*.gz
# IGNORE3=ForgeEssentials/Backups/*
# IGNORE4=timings/*

# echo zip -x "$IGNORE1" "$IGNORE2" "$IGNORE3" "$IGNORE4" -r $TEMPZIP ./*
# zip -x "$IGNORE1" "$IGNORE2" "$IGNORE3" "$IGNORE4" -r $TEMPZIP ./* >/dev/null
# echo zip -x@/home/sita/script/minecraft/minecraft.exclude.txt -r $TEMPZIP ./*
# zip -x@/home/sita/script/minecraft/minecraft.exclude.txt -r $TEMPZIP ./* >/dev/null
echo zip -r $TEMPZIP ./*
zip -r $TEMPZIP ./* >/dev/null

if [ ! -d $ZIPDIR ]; then mkdir $ZIPDIR; fi
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

# echo MAXBACKUP=$MAXBACKUP
[ ! $MAXBACKUP ] || purge $MAXBACKUP

