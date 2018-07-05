#!/bin/bash

lookup_dns_ip() {
  host "$1" | sed -rn 's@^.* has address @@p'
}

findmyip() {
	curl -s http://me.gandi.net
}

case "$1" in
  start)
	sudo ip link set gre0 down
	sudo ip tunnel del gre0
	# sudo ip tunnel add gre0 mode gre remote 104.196.251.199 local 118.168.234.13 ttl 255
	sudo ip tunnel add gre0 mode gre remote $(lookup_dns_ip www.creeper.tw) local $(findmyip) ttl 255
	sudo ip link set gre0 up
	sudo ip addr add 10.10.10.2/24 dev gre0
	ip route show
    exit
    ;;
  stop)
	sudo ip link set gre0 down
	sudo ip tunnel del gre0
	ip route show
    exit
    ;;
  *)
  echo "Usage: $0 {start|stop}"
  exit 1
  ;;
esac
