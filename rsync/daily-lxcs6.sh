#!/bin/bash

exec > >(tee -a -i /tmp/log/$(basename $0).log)
exec 2>&1

echo 
echo ===================
echo $(date +%F_%T)
echo ===================

. /home/admin/script/rsync/backup.sh /share/

