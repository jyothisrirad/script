#!/bin/bash

#=================================
DIR=$(readlink -e $0)
DP0=$(dirname $DIR)

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
cron_comment="#cron comment"
cron_period_max=10
cron_period=$(shuf -i 1-$cron_period_max -n 1)

#=================================
main() {
	echo $cron_period
}

#=================================
case "$1" in
  install)
	addto_crontab ""
	addto_crontab "$cron_comment"
	addto_crontab "*/10 * * * * /usr/bin/batch < $(readlink -e $0)"
	;;
  uninstall)
	delfrom_crontab "$cron_comment"
	delfrom_crontab "$0"
	;;
  *)
  main
  ;;
esac


