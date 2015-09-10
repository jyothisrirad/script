echo Backup $(whoami)/$(hostname)$(pwd) ...

mkdir /tmp/empty

rsync -a /tmp/empty rsync://sitahome.no-ip.org/NetBackup/$(whoami)

rsync -a /tmp/empty rsync://sitahome.no-ip.org/NetBackup/$(whoami)/$(hostname)

rm -r /tmp/empty

rsync -avz --progress --chmod=a=rw,Da+x --fake-super --delete -R $(pwd) rsync://sitahome.no-ip.org/NetBackup/$(whoami)/$(hostname)
