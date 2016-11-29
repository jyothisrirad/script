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

cpu_temp() {
sensors
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
# lscpu | grep 'Model name'
# lscpu | grep MHz
lscpu | grep BogoMIPS
lscpu | grep Virtualization
lscpu | grep cache
more /proc/cpuinfo | grep -m 1 flags
sudo dmidecode -t processor
}

mb_info() {
echo =================================
echo MB Info
echo =================================
sudo dmidecode -t 2 | grep Manufacturer
sudo dmidecode -t 2 | grep Name
sudo dmidecode -t bios | grep Vendor
sudo dmidecode -t bios | grep Date
sudo dmidecode -t bios | grep UEFI
# lspci
echo --- dmidecode -t slot
sudo dmidecode -t slot | grep Type
}

usb_info() {
echo =================================
echo USB Info
echo =================================
sudo lspci -v -s $(lspci | grep -m 1 USB | cut -d" " -f 1)

lsusb | cut -d" " -f 6 | while read line; do
	echo ----------------------------------
	tempfile=/tmp/tempfile
	sudo lsusb -v -d "$line" > $tempfile
	cat $tempfile | grep idVendor
	cat $tempfile | grep idProduct
	cat $tempfile | grep iManufacturer
	cat $tempfile | grep iProduct
	cat $tempfile | grep MaxPower
	cat $tempfile | grep bInterfaceClass
	cat $tempfile | grep bInterfaceSubClass
	cat $tempfile | grep bInterfaceProtocol
	cat $tempfile | grep 'Device can operate'
	rm $tempfile
done
}

network_info() {
echo =================================
echo NETWORK Info
echo =================================
lspci -v -s $(lspci | grep Ethernet | cut -d" " -f 1)
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
sudo lshw -short -C memory
# sudo lshw -class memory
sudo dmidecode -t memory | grep Size
sudo dmidecode -t memory | grep Bank
sudo dmidecode -t memory | grep -P "\tType:"
sudo dmidecode -t memory | grep -P "\tSpeed"
sudo dmidecode -t memory | grep Clock
sudo dmidecode -t memory | grep 'Configured voltage'
}

gpu2d_info() {
echo =================================
echo GPU 2D Info
echo =================================
lspci -v -s $(lspci | grep VGA | cut -d" " -f 1)
}

gpu3d_info() {
echo =================================
echo GPU 3D Info
echo =================================
glxinfo
aticonfig --odgc
nvclock
}

disk_info() {
echo =================================
echo DISK Info
echo =================================
sudo lspci -v -s $(lspci | grep SATA | cut -d" " -f 1)
# sudo lshw -class disk -class storage
sudo lshw -short -C disk

lsblk | grep -P ^sd | cut -d" " -f 1 | while read line; do
	echo ----------------------------------
	tempfile=/tmp/tempfile
	sudo hdparm -I /dev/"$line" > $tempfile
	cat $tempfile | grep /dev/sd
	cat $tempfile | grep Model
	cat $tempfile | grep 'Serial Number'
	cat $tempfile | grep 'device size'
	rm $tempfile
done
}

smart1() {
	echo smartctl -a /dev/$1 				>$2
	sudo smartctl -a /dev/$1 				>>$2
}

smart2() {
	echo smartctl -d sat -a /dev/$1 		>$2
	sudo smartctl -d sat -a /dev/$1 		>>$2
}

smart3() {
	echo smartctl -d scsi -a /dev/$1 		>$2
	sudo smartctl -d scsi -a /dev/$1 		>>$2
}

smart() {
	smart1 $1 $2
	grep -q "START OF READ SMART DATA SECTION" $2
	if [ $? -eq 0 ]; then return; fi
	
	smart2 $1 $2
	grep -q "START OF READ SMART DATA SECTION" $2
	if [ $? -eq 0 ]; then return; fi
	
	smart3 $1 $2
	grep -q "START OF READ SMART DATA SECTION" $2
	if [ $? -eq 0 ]; then return; fi
}

disksmart_status() {
echo =================================
echo DISK Smart Status
echo =================================

lsblk | grep -P ^sd | cut -d" " -f 1 | while read line; do
	tempfile=/tmp/tempfile
	smart $line $tempfile
	echo ---------------------------------
	cat $tempfile | grep '/dev/sd'
	echo ---------------------------------
	cat $tempfile | grep 'Vendor:'
	cat $tempfile | grep 'Model Family'
	cat $tempfile | grep 'Device Model'
	cat $tempfile | grep 'Product'
	cat $tempfile | grep 'Serial'
	cat $tempfile | grep 'User Capacity'
	cat $tempfile | grep 'Sector Sizes'
	cat $tempfile | grep 'Logical block size'
	cat $tempfile | grep 'overall-health'
	cat $tempfile | grep 'Health Status'
	cat $tempfile | grep 'ID#'
	cat $tempfile | grep 'Reallocated_Sector_Ct'
	cat $tempfile | grep 'Reported_Uncorrect'
	cat $tempfile | grep 'Command_Timeout'
	cat $tempfile | grep 'Current_Pending_Sector'
	cat $tempfile | grep 'Offline_Uncorrectable'
	cat $tempfile | grep 'SSD_Life_Left'
	cat $tempfile | grep 'Lifetime Writes from Host'
	cat $tempfile | grep 'E9 '
	cat $tempfile | grep 'Power_On_Hours'
	cat $tempfile | grep 'Temperature_Celsius'
	cat $tempfile | grep 'occurred at disk power-on lifetime'
	cat $tempfile | grep 'FAILING_NOW'
	cat $tempfile | grep 'Unknown USB'
	cat $tempfile | grep 'output error'
	cat $tempfile | grep 'SMART command failed'
	rm $tempfile
done
}

os_info() {
echo =================================
echo OS Info
echo =================================
uname -a
if hash lsb_release 2>/dev/null; then lsb_release -a; fi
if [ -f /etc/lsb-release ]; then cat /etc/lsb-release; fi
if [ -f /etc/redhat-release ]; then cat /etc/redhat-release; fi
if [ -f /etc/issue.net ]; then cat /etc/issue.net; fi
if [ -f /etc/debian_version ]; then cat /etc/debian_version; fi
}

uptime_info() {
echo =================================
echo UPTIME Info
echo =================================
# uptime
w
}

mailtext() {
	# echo $1 | mailx -s "[LOG] $COMPUTERNAME $0" -r "Sita Liu<egreta.su@msa.hinet.net>" -S smtp="msa.hinet.net" -a $LOG -a $TXT1 chsliu@gmail.com
	echo $1 | sudo mailx -s "[LOG] $(hostname) $0" chsliu@gmail.com
}



postfix_fix() {
	sudo mkdir /var/spool/postfix
	sudo chown postfix:postdrop /var/spool/postfix
	sudo chmod 730 /var/spool/postfix
	
	# sudo mkdir /var/spool/postfix/maildrop
	# sudo chown postfix:postdrop /var/spool/postfix/maildrop
	# sudo chmod 730 /var/spool/postfix/maildrop
	
	# sudo mkdir /var/spool/postfix/public
	# sudo mkdir /var/spool/postfix/public/pickup
	# sudo chown postfix:postdrop /var/spool/postfix/public/pickup
	# sudo chmod 730 /var/spool/postfix/public/pickup
	
	sudo /etc/init.d/postfix restart
}

#Start-Stop here
case "$1" in
  install)
		sudo apt install dstat ethtool lshw lm-sensors

		postfix_fix
		
        addto_crontab "#disk smart info"
        addto_crontab "0 1 1 11 * $(readlink -e $0) smart"
        ;;
  uninstall)
        delfrom_crontab "#disk smart info"
        delfrom_crontab "$(basename $0)"
        ;;
  info)
        cpu_info
		cpu_temp
		mb_info
		usb_info
		ram_info
		gpu2d_info
		gpu3d_info
		network_info
		disk_info
		os_info
		uptime_info
		
		# sudo lshw
		# sudo lshw -businfo
        ;;
  mb)
        cpu_info
		cpu_temp
		mb_info
		usb_info
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
  log)		
		mailtext "Hello World"
        ;;
  watch)
		# dstat --cpu24 -m -s -g -d -n
        ;;
  *)
		echo "Usage: /etc/init.d/$0 {install|uninstall|info|mb|gpu|net|disk|smart|os|log|watch}"
		exit 1
		;;
esac

