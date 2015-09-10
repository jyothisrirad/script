rsync -avz --progress --chmod=a=rw,Da+x --fake-super --delete . rsync://sitahome.no-ip.org/NetBackup/sita/$(hostname)$(pwd)
