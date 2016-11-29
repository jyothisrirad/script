sudo dpkg-reconfigure tzdata

sudo cp /usr/share/zoneinfo/Asia/Taipei /etc/localtime

sudo apt-get install -y ntpdate

sudo ntpdate time.stdtime.gov.tw
sudo ntpdate time.stdtime.gov.tw
sudo ntpdate time.stdtime.gov.tw

sudo hwclock -w
