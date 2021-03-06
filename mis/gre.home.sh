#!/bin/bash

lookup_dns_ip() {
  host "$1" | sed -rn 's@^.* has address @@p'
}

findmyip() {
	curl -s http://me.gandi.net
}

DEV="gre1"
ADDR="10.10.10.2"
MASK="24"
GREIP=$(lookup_dns_ip www.creeper.tw)
HOMEIP=$(lookup_dns_ip gem.creeper.tw)

case "$1" in
  start)
	sudo ip link set $DEV down
	sudo ip tunnel del $DEV
	
	# sudo ip tunnel add gre1 mode gre remote 104.196.251.199 local 118.168.234.13 ttl 255
	# sudo ip tunnel add $DEV mode gre remote $(lookup_dns_ip www.creeper.tw) local $(findmyip) ttl 255
	sudo iptunnel add $DEV mode gre remote $GREIP local $HOMEIP ttl 255
	
	sudo ip link set $DEV up
	sudo ip addr add $ADDR/$MASK dev $DEV
	
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
