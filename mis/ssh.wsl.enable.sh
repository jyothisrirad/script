
addto_file() {
        file=$1

        sudo touch $file

        if ! sudo grep -Fxq "$2" $file; then
                echo "$2" | sudo tee -a $file
        fi

        sudo chown $(whoami):crontab $file
}


sudo apt -y remove openssh-server
sudo apt -y install openssh-server

sudo sed -i 's/PermitRootLogin without-password/PermitRootLogin no/g' /etc/ssh/sshd_config
addto_file /etc/ssh/sshd_config "AllowUsers $(whoami)"
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i 's/UsePrivilegeSeparation yes/UsePrivilegeSeparation no/g' /etc/ssh/sshd_config

sudo service ssh --full-restart
