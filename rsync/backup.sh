#!/bin/bash

#=================================
rsync_mkdir() {
empty=/tmp/empty
mkdir $empty >/dev/null
pushd $empty >/dev/null

rsync -a . rsync://$1

popd >/dev/null
rm -rf $empty
}

rsync_check_path() {
# 1: prefix
# 2: computername
# 3: dirname
# 4: basename

rsync_mkdir $1
rsync_mkdir $1/$2
rsync_mkdir $1/$2/$3
rsync_mkdir $1/$2/$3/$4
}

#=================================
if [[ -z "$1" ]] 
then
    echo $0 [dir] [pattern files]
    exit
fi

#=================================
DP0=$(dirname $0)
DIR=$(readlink -e $1)
COMPUTERNAME=$(hostname)
USERNAME=$(whoami)
TODAY=$(date +"%Y-%m-%d")
MONTH=$(date +"%Y-%m")
LOG=/tmp/rsync.$(basename $DIR).txt
#echo $LOG

#=================================
#echo arg2=$2
if [[ ! -z ${2+x} && -f $2 ]] 
then 
    #echo "arg2 is set to '$2'"
    #echo user patterns, $2
    PATTERNS=$(readlink -e $2)
else 
    #echo "arg2 is unset"
    #echo default patterns
    PATTERNS=$(readlink -e $DP0/patterns.txt)
fi
#echo PATTERNS=$PATTERNS

if [ -e $DP0/host-$COMPUTERNAME.sh ] 
then
	. $DP0/host-$COMPUTERNAME.sh
	#echo $HOST, $HOSTPATH
else
	. $DP0/host.sh
fi

#=================================
#RPATH="mkdir -p /$USERNAME/$COMPUTERNAME/$(basename $(dirname $DIR))/$(basename $DIR) && rsync"
OPTIONS="-avz --progress --chmod=a=rw,Da+x --fake-super --delete --delete-excluded --exclude-from=$PATTERNS --backup --backup-dir=/recycle/$MONTH/$TODAY/$USERNAME/$COMPUTERNAME/$(basename $(dirname $DIR))/$(basename $DIR)"
SRC=.
DST=rsync://$HOST/$HOSTPATH/$USERNAME/$COMPUTERNAME/$(basename $(dirname $DIR))/$(basename $DIR)
#echo $OPTIONS
#echo $SRC $DST

rsync_check_path $HOST/$HOSTPATH/$USERNAME $COMPUTERNAME $(basename $(dirname $DIR)) $(basename $DIR)

#=================================
pushd $1 >/dev/null
echo [ Backup $DIR ] >>$LOG
echo rsync $OPTIONS $SRC "$DST" >>$LOG

rsync $OPTIONS $SRC "$DST" &>>$LOG

popd >/dev/null

#=================================
cat $LOG

mailx -s "[LOG] $COMPUTERNAME $0" -r "Sita Liu<egreta.su@msa.hinet.net>" -S smtp="msa.hinet.net" -a $0 -a $LOG chsliu@gmail.com </dev/null

rm $LOG

#=================================

