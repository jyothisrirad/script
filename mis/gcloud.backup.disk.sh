#!/bin/bash
# !!! not working yet... !!!

. /home/sita/script/include/console.color

SOURCEDISK="/dev/sda"
RAWDISK="disk.raw"
GZDISK="sda.image.tar.gz"

pushd /tmp

echo -e ${GREEN}Dumping $SOURCEDISK to $RAWDISK ... ${NC}
sudo dd if=$SOURCEDISK of=$RAWDISK bs=4M conv=sparse

echo -e ${GREEN}Comressing $RAWDISK to $GZDISK ... ${NC}
sudo tar -Sczf $GZDISK $RAWDISK

sudo chown sita:sita $GZDISK
