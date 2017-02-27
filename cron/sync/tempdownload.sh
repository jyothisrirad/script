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
	
	# ~/script/youtube/y720best.sh "$DST" --download-archive archive.txt "https://www.youtube.com/playlist?list=PLL7H7U6zd1f0df68ySccybaTThFdcQCaZ" &>log.txt
	
	# ~/script/youtube/get.web.720.sh "https://www.youtube.com/playlist?list=PLL7H7U6zd1f0df68ySccybaTThFdcQCaZ" &>log.txt
	
	# ~/script/youtube/y480best.sh "$DST" --download-archive archive.txt "https://www.youtube.com/playlist?list=PLL7LXvkhjsoLrNMDyhYucp8A8dP8y7VIf" &>log.txt
	
	# ~/script/youtube/get.web.480.sh "https://www.youtube.com/playlist?list=PLL7LXvkhjsoLrNMDyhYucp8A8dP8y7VIf" &>log.txt
	
	~/script/youtube/get.web.480.sh https://www.youtube.com/playlist?list=PLslrb_iLVxay4W4xeHu5js1FYYDOyoofH
	~/script/youtube/get.web.480.sh https://www.youtube.com/playlist?list=PLepGdSz9ElR65yBqSve_PDea6hkbcKDKA
	~/script/youtube/get.web.480.sh https://www.youtube.com/playlist?list=PLVDKkoOMy7h3UyhORart7_7_0hyed5sCQ
	~/script/youtube/get.web.480.sh https://www.youtube.com/playlist?list=PL2hbd_KDYio1YY6-pfV-P5ANr2ukoYY6k
	~/script/youtube/get.web.480.sh https://www.youtube.com/playlist?list=PL100_lBAnB-AoFdt-U2JPz7EL_utYck7z
	~/script/youtube/get.web.480.sh https://www.youtube.com/playlist?list=PLTIgHk4dlelQ52tl60iLOWCGUi9znPXKb
	~/script/youtube/get.web.480.sh https://www.youtube.com/playlist?list=PL68DE6C75DD0D4B2D
	~/script/youtube/get.web.480.sh https://www.youtube.com/playlist?list=PLslrb_iLVxazy40cgViX0Veebvq3MCyVG

	~/script/youtube/get.web.480.sh https://www.youtube.com/playlist?list=PL9mGn4QMy3GQV94WrYfD_rubsEYT7reKJ
	~/script/youtube/get.web.480.sh https://www.youtube.com/playlist?list=PLD12F35DC852803FD
	~/script/youtube/get.web.480.sh https://www.youtube.com/playlist?list=PL0xzMlxZRTv_rBNmXaSOW5RaEJTGmjbcH
	~/script/youtube/get.web.480.sh https://www.youtube.com/playlist?list=PL60eRp_UW37LViR0KTil0lFePrhP0qrRF
	~/script/youtube/get.web.480.sh https://www.youtube.com/playlist?list=PLD_hOCJtWd4Oldt0YZCfwaynyEFflyolH
	~/script/youtube/get.web.480.sh https://www.youtube.com/playlist?list=PLerUZlaD8TFznWACSVWSCOF1IKbefZ9hv
	~/script/youtube/get.web.480.sh https://www.youtube.com/playlist?list=PLD12F35DC852803FD
}

#=================================
case "$1" in
  install)
	addto_crontab ""
	addto_crontab "$cron_comment"
	addto_crontab "$cron_min $cron_hour * * * \"$(readlink -e "$0")\""
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


