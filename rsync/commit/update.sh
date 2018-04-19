#/bin/bash

DIR=$(readlink -e $0)
DP0=$(dirname "$DIR")
pname=$(basename "$DP0")
pname_fixed=${pname// /\\ }

. "$DP0/config.sh"

options="--recursive --links --times --verbose --compress --fuzzy --progress --delete-after --exclude-from ./ignores.txt --backup --backup-dir=/home/$(whoami)/$backup_local_root"

src="rsync://$rsync_root/$pname"

dst=..


pushd "$DP0"

echo rsync $options "$src" $dst
rsync $options "$src" $dst

popd

