#/bin/bash

#============================================
. /home/sita/script/minecraft/include/java_args.sh

#============================================
TODAY=$(date +"%Y-%m-%d")
MONTH=$(date +"%Y-%m")


export backup_remote_root=recycle/$MONTH/$TODAY/rsync
export backup_local_root=$backup_remote_root
export rsync_root=sita.ddns.net/NetBackup/rsync

#============================================
USERNAME="sita"
ZIPDIR=/mnt/backup
BACKUPPATH="/mnt/backup"
JARFILE=$(basename $(find . -maxdepth 1 -name '*.jar' | head -n 1))
LOG="$MCPATH/proxy.log.0"
OPTMEM="-Xmx1G -Dfile.encoding=UTF-8"
JAVAARGS="$OPTMEM $OPTGC $OPTLOG"

NEWJAR=$BACKUPPATH/server/$JARFILE
[ -f $NEWJAR ] || rsync -avzq $NEWJAR .
