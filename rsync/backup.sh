#!/bin/bash

#=================================
rsync_mkdir() {
empty=/tmp/empty/
mkdir $empty &>/dev/null
#pushd $empty >/dev/null

#rsync -a . rsync://$1
rsync -a $empty rsync://$1

#popd >/dev/null
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

rsync_mkdir2() {
empty=/tmp/empty/
mkdir $empty &>/dev/null

#echo rsync -a $empty $1
rsync -a $empty $1

rm -rf $empty
}

rsync_mkdir3() {
dirs=( $(find /etc -type d -empty) )
empty=${dirs[0]}/

#echo rsync -a $empty $1
rsync -a $empty $1 &>/dev/null
}

rsync_check_path2() {
    if [[ ! -z "$1" &&  ! $1 == "rsync:" ]]
    then
        #echo =$1, $(dirname $1)
        if [ $1 == $(dirname $1) ]; then return; fi
        rsync_check_path2 $(dirname $1)
        rsync_mkdir3 $1
    fi
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
TXT1=/tmp/$(basename $0).txt
LOG=/tmp/rsync.$(basename $DIR).$TODAY.txt
#echo $LOG

if [ -e $LOG ]
then
    cp $0 $TXT1

    MSG="Aborting because logfile already exists, probably another thread is currently running."
    echo $MSG | mailx -s "[LOG] $COMPUTERNAME $0 ABORT" -r "Sita Liu<egreta.su@msa.hinet.net>" -S smtp="msa.hinet.net" -a $LOG -a $TXT1 chsliu@gmail.com

    rm $LOG $TXT1
    exit
fi

#echo whoami: $(whoami) >>$LOG
#echo '$0': $0 >>$LOG
#echo '$1': $1 >>$LOG
#echo '$2': $2 >>$LOG

#ls -la $1 >>$LOG

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
SRC=$DIR/

if [ $(basename $(dirname $DIR)) == "/" ]; then
	PATHTAIL=$(basename $DIR)
	# OPTIONS="-avz --progress --chmod=a=rw,Da+x --fake-super --delete --delete-excluded --exclude-from=$PATTERNS --backup --backup-dir=/recycle/$MONTH/$TODAY/$USERNAME/$COMPUTERNAME/$(basename $DIR)"
	# DST=rsync://$HOST/$HOSTPATH/$USERNAME/$COMPUTERNAME/$(basename $DIR)
else
	PATHTAIL=$(basename $(dirname $DIR))/$(basename $DIR)
	# OPTIONS="-avz --progress --chmod=a=rw,Da+x --fake-super --delete --delete-excluded --exclude-from=$PATTERNS --backup --backup-dir=/recycle/$MONTH/$TODAY/$USERNAME/$COMPUTERNAME/$(basename $(dirname $DIR))/$(basename $DIR)"
	# DST=rsync://$HOST/$HOSTPATH/$USERNAME/$COMPUTERNAME/$(basename $(dirname $DIR))/$(basename $DIR)
fi

OPTIONS="-avz --progress --chmod=a=rw,Da+x --fake-super --no-owner --no-group --omit-dir-times --delete --delete-excluded --exclude-from=$PATTERNS --backup --backup-dir=/recycle/$MONTH/$TODAY/$USERNAME/$COMPUTERNAME/$PATHTAIL"
DST=rsync://$HOST/$HOSTPATH/$USERNAME/$COMPUTERNAME/$PATHTAIL

#echo $OPTIONS
#echo $SRC $DST

#rsync_check_path $HOST/$HOSTPATH/$USERNAME $COMPUTERNAME $(basename $(dirname $DIR)) $(basename $DIR)
rsync_check_path2 $DST 

#=================================
#pushd $1 >>$LOG
echo [ Backup $DIR ] >>$LOG
echo rsync $OPTIONS $SRC "$DST" >>$LOG

rsync $OPTIONS $SRC "$DST" &>>$LOG

#popd >>$LOG

#=================================
cat $LOG
cp $0 $TXT1

echo $0 | mailx -s "[LOG] $COMPUTERNAME $0" -r "Sita Liu<egreta.su@msa.hinet.net>" -S smtp="msa.hinet.net" -a $LOG -a $TXT1 chsliu@gmail.com

rm $LOG $TXT1

#=================================

