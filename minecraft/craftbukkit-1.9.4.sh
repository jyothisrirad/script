#!/bin/bash

FULL=$(readlink -e $0)
DP0=$(dirname $FULL)

. $DP0/config.sh

echo -e ${GREEN}
echo ===================================
echo Restore from Lastest ZIP to RAMDISK
echo ===================================
echo -e ${NC}

FILE=$(basename $FULL)
NAME="${FILE%.*}"
DSTDIR=/tmp/$NAME
# name=$(echo $FILE | cut -f 2- -d '.')
# name=$(basename $FILE .sh)
# echo $name

# echo $NAME

ZIPFILE=$(ls -at $ZIPDIR/$NAME*.zip|head -1)

# echo $ZIPFILE

echo -e ${GREEN}
echo Restore from $ZIPFILE
echo Restore to   $DSTDIR
echo -e ${NC}

IGNORE=logs*

unzip -o $ZIPFILE -x "$IGNORE" -d $DSTDIR


echo -e ${GREEN}
echo ==========
echo Run Server
echo ==========
echo -e ${NC}

chmod +x /tmp/$NAME/run.sh
/tmp/$NAME/run.sh


echo -e ${GREEN}
echo ==============
echo Backup to ZIP?
echo ==============
echo -e ${NC}

read -p "Press [Enter] key to start backup..."

chmod +x /tmp/$NAME/backup.sh
/tmp/$NAME/backup.sh

