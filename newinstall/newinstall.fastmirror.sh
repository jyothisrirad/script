###################
###getfastmirror###
###################

#####
sudo apt-get install -y wget unzip python-setuptools python-apt

###getfastmirror
if [ ! -f /etc/apt/sources.list.original ]; then
  sudo cp /etc/apt/sources.list /etc/apt/sources.list.original
fi
cd /tmp
wget https://github.com/hychen/getfastmirror/archive/master.zip
unzip -o master.zip
cd getfastmirror-master/
sudo ./setup.py install
cd ..
rm master.zip
sudo rm -rf getfastmirror-master
sudo getfastmirror update -t
sudo rm /etc/apt/sources.list.d/*.*.*
python -mplatform | grep debian && sudo sed -i 's/ubuntu/debian/' /etc/apt/sources.list

#####
sudo apt-get update
