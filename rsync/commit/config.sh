#/bin/bash

TODAY=$(date +"%Y-%m-%d")
MONTH=$(date +"%Y-%m")


export backup_remote_root=recycle/$MONTH/$TODAY/rsync
export backup_local_root=$backup_remote_root
export rsync_root=sita.ddns.net/NetBackup/rsync
