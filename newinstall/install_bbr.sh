#!/bin/bash

bbr=/tmp/bbr.sh
wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh -O $bbr && chmod +x $bbr && sudo $bbr

uname -r

sudo sysctl net.ipv4.tcp_available_congestion_control

sudo sysctl net.ipv4.tcp_congestion_control

sudo sysctl net.core.default_qdisc

echo lsmod \| grep bbr
lsmod | grep bbr
