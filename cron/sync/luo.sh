#!/bin/bash

#=================================
cron_comment="#$(basename "$0")"
cron_min_period_max=60
cron_min=$(shuf -i 1-$cron_min_period_max -n 1)
cron_hour_period_max=24
cron_hour=$(shuf -i 1-$cron_hour_period_max -n 1)

#=================================
crontab_status() {
	status=$(crontab -l)
	return $?
}

addto_crontab() {
	cronfile=/var/spool/cron/crontabs/$(whoami)

	if ! crontab_status; then
		echo "" | sudo tee -a $cronfile
		sudo chown $(whoami):crontab $cronfile
	fi
	
	if ! sudo grep -Fxq "$*" $cronfile; then
		echo "$*" | sudo tee -a $cronfile
	fi
}

delfrom_crontab() {
	cronfile=/var/spool/cron/crontabs/$(whoami)

	line=$*
	line=$(echo "$line" | sed 's/\//\\\//g')
	sudo sed -i "/$line/d" $cronfile
}

checkdir() {
	if [ ! -d "$1" ]; then
		mkdir "$1"
	fi
}

#=================================
update() {
	sudo pip install --upgrade youtube_dl
}

#=================================
main() {
	DP0=$(dirname "$(readlink -e "$0")")
	. $DP0/config.sh

	filename=$(basename "$0")
	filename="${filename%.*}"
	DST=$DSTROOT/$filename
	checkdir "$DST"
	
	# echo Entering Dir "$DST"
	cd "$DST"
	
	~/script/youtube/get.web.480.sh "https://www.youtube.com/user/logictalkshow/videos" &>log.txt
}

#=================================
case "$1" in
  install)
	addto_crontab ""
	addto_crontab "$cron_comment"
	addto_crontab "$cron_min $cron_hour * * 4,5 \"$(readlink -e "$0")\""
	;;
  uninstall)
	delfrom_crontab "$cron_comment"
	delfrom_crontab "$0"
	;;
  update)
	update
	;;
  *)
  main
  ;;
esac


