#!/bin/bash
### 
# ighost=$(hostname | grep -E "(-[0-9a-z]{4})")

### 
id="sita@changen.com.tw"
gstorage="creeper-tw2"
localpath="/mnt/$gstorage"
localpath2="/mnt/$gstorage/$(hostname)"
keyfile="/home/sita/.gcloud/$id.json"
# gameid=s65
myfile="/home/sita/.my.cnf"

	
### 
addto_crontab() {
	(crontab -l; echo "$*") | crontab -
}

delfrom_crontab() {
	line=$*
	line=$(echo "$line" | sed 's/\//\\\//g')
	crontab -l | sed "/$line/d" | crontab -
}

gs_mount() {
	gsmounted=$(df -h|grep $gstorage)
	[ ! -d "$localpath" ] && sudo mkdir $localpath && sudo chown sita:sita $localpath
	[ -z "$gsmounted" ] && gcsfuse --key-file $keyfile $gstorage $localpath
}

# my_ip_address() {
    # curl -s4 http://me.gandi.net
# }

back_log() {
	# if [ ! -z "$ighost" ]; then
		# DIR=$(readlink -e "$0")
		# DP0=$(dirname "$DIR")
		
		gs_mount
        
        [ ! -d "$localpath2" ] && sudo mkdir $localpath2 && sudo chown sita:sita $localpath2
		
		# archive=/tmp/$(date '+%Y%m%d_%H%M')-$(my_ip_address)-$(hostname)-proxy.log.0.tar.gz
		# pushd $DP0
		# tar -czvf $archive proxy.log.0
		# popd
		# mv $archive $localpath
		
		# archive=/tmp/$(date '+%Y%m%d_%H%M')-$(my_ip_address)-$(hostname)-kern.log.tar.gz
		# pushd /var/log
		# tar -czvf $archive kern.log
		# popd
		# mv $archive $localpath
		
		# archive=/tmp/$(date '+%Y%m%d_%H%M')-$(my_ip_address)-$(hostname)-netstat.log.gz
		# netstat -natp | gzip -9 > $archive
		# mv $archive $localpath
		
		# archive=/tmp/$(date '+%Y%m%d_%H%M')-$(my_ip_address)-$(hostname)-nf_conntrack.log.gz
		# sudo cat /proc/net/nf_conntrack | gzip -9 > $archive
		# mv $archive $localpath
		
		archive=/tmp/$(date '+%Y%m%d_%H%M')-$(hostname)-alltable.sql.gz
		mysqldump --defaults-extra-file=$myfile -h localhost --single-transaction --quick --lock-tables=false --all-databases | gzip -9 > $archive
		mv $archive $localpath2

	# fi
}

case "$1" in
  install)
    delfrom_crontab "$(basename $0)"
	addto_crontab "# $(basename $0)"
	addto_crontab "0 0 * * * /bin/bash $(readlink -e $0)"
    # [ -z "$ighost" ] && addto_crontab "*/30 * * * * /bin/bash $(readlink -e $0)"
    # [ ! -z "$ighost" ] && addto_crontab "*/10 * * * * /bin/bash $(readlink -e $0)"
	
	echo [client]>$myfile
	echo user=minecraft>>$myfile
	echo password=goodview>>$myfile
	chmod 600 $myfile
	
    exit
    ;;
  remove)
    delfrom_crontab "$(basename $0)"
    exit
    ;;
  log)
    back_log
    exit
    ;;
esac

### 
# no_one_playing() {
    # . /home/sita/script/minecraft/alias.minecraft
    # $gameid
    
    # export LOG_DELAY=7
    # /tmp/$mcver do glist | grep --quiet ' 0 players\|online: 0'
	# ret=$?
    # export LOG_DELAY=.1
    # return $ret
# }

# stop_game() {
    # . /home/sita/script/minecraft/alias.minecraft
    # $gameid

    # /tmp/$mcver do end
	# sleep 10
    # /tmp/$mcver start
# }

### 
# if no_one_playing; then
  # echo "no one is playing"
# fi

# if no_one_playing; then
  # stop_game
# fi

back_log
