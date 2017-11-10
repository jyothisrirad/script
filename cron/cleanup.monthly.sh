#!/bin/bash

#=================================
cron_comment="#$(basename "$0")"
cron_min_period_max=60
cron_min=$(shuf -i 1-$cron_min_period_max -n 1)
cron_hour_period_max=24
cron_hour=$(shuf -i 1-$cron_hour_period_max -n 1)

#=================================
DIR=$(readlink -e "$0")
DP0=$(dirname "$DIR")

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

#=================================
main() {
	. $DP0/taskschd/cleanup.$(hostname).sh
}

#=================================
case "$1" in
  install)
	addto_crontab ""
	addto_crontab "$cron_comment"
	addto_crontab "$cron_min $cron_hour 1 * * $(readlink -e $0)"
	;;
  uninstall)
	delfrom_crontab "$cron_comment"
	delfrom_crontab "$0"
	;;
  *)
  main
  ;;
esac


