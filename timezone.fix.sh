sudo dpkg-reconfigure tzdata

sudo cp /usr/share/zoneinfo/Asia/Taipei /etc/localtime

sudo ntpdate time.stdtime.gov.tw

sudo hwclock -w
