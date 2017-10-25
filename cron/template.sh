#!/bin/bash

#=================================
cron_comment="#$(basename "$0")"
	
#=================================
DIR=$(readlink -e "$0")
DP0=$(dirname "$DIR")

#=================================
crontab_status() {
	status=$(crontab -l)
	return $?
}

#=================================
define_time() {
	cron_min_period_max=60
	cron_min=$(shuf -i 1-$cron_min_period_max -n 1)
	cron_hour_period_max=24
	cron_hour=$(shuf -i 1-$cron_hour_period_max -n 1)
	cron_day='*'
	cron_month='*'
	cron_wday='*'
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

#=================================
usage() {
	echo "Usage: $0 {install|uninstall}"
}

#=================================
case "$1" in
  install)
	[ "$cron_min" ] || define_time
	addto_crontab ""
	addto_crontab "$cron_comment"
	# addto_crontab "$cron_min $cron_hour $cron_day $cron_month $cron_wday /usr/bin/batch < $(readlink -e $0)"
	addto_crontab "$cron_min $cron_hour $cron_day $cron_month $cron_wday $(readlink -e $0)"
	crontab -l
	exit
	;;
  uninstall)
	delfrom_crontab "$cron_comment"
	delfrom_crontab "$0"
	crontab -l
	exit
	;;
  help)
	usage
	exit
	;;
esac


