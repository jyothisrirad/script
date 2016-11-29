#!/bin/sh

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

cpu_info() {
echo =================================
echo CPU Info
echo =================================
lscpu | grep Architecture
lscpu | grep 'Byte Order'
lscpu | grep op-mode
lscpu | grep Thread
lscpu | grep Core
lscpu | grep Socket
lscpu | grep Vendor
lscpu | grep 'Model name'
lscpu | grep MHz
lscpu | grep BogoMIPS
lscpu | grep Virtualization
lscpu | grep cache
more /proc/cpuinfo | grep -m 1 flags
}

mb_info() {
echo =================================
echo MB Info
echo =================================
sudo dmidecode -t 2 | grep Manufacturer
sudo dmidecode -t 2 | grep Name
lspci
}

network_info() {
echo =================================
echo NETWORK Info
echo =================================
dmesg | grep eth0 | grep up
sudo mii-tool -v eth0 | grep status
sudo ethtool eth0 | grep Speed
sudo ifconfig eth0 | grep HWaddr
sudo ifconfig eth0 | grep addr:
sudo ifconfig eth0 | grep packets:
sudo ifconfig eth0 | grep bytes:
}

ram_info() {
echo =================================
echo RAM Info
echo =================================
sudo dmidecode --type 17 | grep Size
sudo dmidecode --type 17 | grep Bank
sudo dmidecode --type 17 | grep Type:
sudo dmidecode --type 17 | grep -P "\tSpeed"
sudo dmidecode --type 17 | grep Clock
sudo dmidecode --type 17 | grep 'Configured voltage'
}

gpu2d_info() {
echo =================================
echo GPU 2D Info
echo =================================
}

gpu3d_info() {
echo =================================
echo GPU 3D Info
echo =================================
}

disk_info() {
echo =================================
echo DISK Info
echo =================================
}

disksmart_status() {
echo =================================
echo DISK Smart Status
echo =================================
}

os_info() {
echo =================================
echo OS Info
echo =================================
}

uptime_info() {
echo =================================
echo UPTIME Info
echo =================================
}


#Start-Stop here
case "$1" in
  install)
        addto_crontab "#disk smart info"
        addto_crontab "0 1 1 11 * $(readlink -e $0) smart"
        ;;
  uninstall)
        delfrom_crontab "#disk smart info"
        delfrom_crontab "$(basename $0)"
        ;;
  info)
        cpu_info
		mb_info
		ram_info
		gpu2d_info
		gpu3d_info
		network_info
		disk_info
		os_info
		uptime_info
        ;;
  inventory)
        ;;
  mb)
        cpu_info
		mb_info
		ram_info
        ;;
  gpu)
		gpu2d_info
		gpu3d_info
        ;;
  net)
		network_info
        ;;
  disk)
		disk_info
        ;;
  smart)
		disksmart_status
		;;
  os)
		os_info
		uptime_info
        ;;
  *)
		echo "Usage: /etc/init.d/$0 {install|uninstall|info|inventory|mb|gpu|net|disk|smart|os}"
		exit 1
		;;
esac

