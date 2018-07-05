#!/bin/bash

lookup_dns_ip() {
  host "$1" | sed -rn 's@^.* has address @@p'
}

findmyip() {
	curl -s http://me.gandi.net
}

DEV="gre1"
ADDR="10.10.10.1"

case "$1" in
  start)
	# sudo sysctl -w net.ipv4.ip_forward=1
	
	sudo ip link set $DEV down
	sudo ip tunnel del $DEV
	
	# sudo ip tunnel add gre1 mode gre remote 118.168.234.13 local 104.196.251.199 ttl 255
	# sudo ip tunnel add $DEV mode gre remote $(lookup_dns_ip gem.creeper.tw) local $(findmyip) ttl 255
	sudo iptunnel add $DEV mode gre remote $(lookup_dns_ip gem.creeper.tw) local $(findmyip) ttl 255
	
	sudo ip link set $DEV up
	sudo ip addr add $ADDR/24 dev $DEV
	
	ip route show
	
	# /sbin/iptables -t nat -A POSTROUTING -s 192.168.10.0/30 -j SNAT --to-source VPS_GLOBAL_IP
	# /sbin/iptables -t nat -A PREROUTING -p tcp -d VPS_GLOBAL_IP --dport 25565 -j DNAT --to-destination 192.168.10.1:25565
	# /sbin/iptables -A FORWARD -p tcp -d 192.168.1.1 --dport 25565 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
    exit
    ;;
  stop)
	# sudo sysctl -w net.ipv4.ip_forward=0
	
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
