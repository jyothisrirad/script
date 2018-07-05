#!/bin/bash

lookup_dns_ip() {
  host "$1" | sed -rn 's@^.* has address @@p'
}

findmyip() {
	curl -s http://me.gandi.net
}

DEV="gre1"

case "$1" in
  start)
	sudo ip link set $DEV down
	sudo ip tunnel del $DEV
	# sudo ip tunnel add gre1 mode gre remote 118.168.234.13 local 104.196.251.199 ttl 255
	sudo ip tunnel add $DEV mode gre remote $(lookup_dns_ip gem.creeper.tw) local $(findmyip) ttl 255
	sudo ip link set $DEV up
	sudo ip addr add 10.10.10.1/24 dev $DEV
	ip route show
    exit
    ;;
  stop)
	sudo ip link set $DEV down
	sudo ip tunnel del $DEV
	ip route show
    exit
    ;;
  *)
  echo "Usage: $0 {start|stop}"
  exit 1
  ;;
esac
