#!/bin/bash

#=================================
rule_reset() {
	iptables -F
	iptables -X
	iptables -t nat -F
	iptables -t nat -X
	iptables -t mangle -F
	iptables -t mangle -X
	iptables -t raw -F
	iptables -t raw -X
	iptables -t security -F
	iptables -t security -X
}

#=================================
rule_dump() {
	iptables-save
}

#=================================
### 1: Drop invalid packets ###
rule1_drop_invalid() {
	/sbin/iptables -t mangle -A PREROUTING -m conntrack --ctstate INVALID -j DROP
}

#=================================
### 2: Drop TCP packets that are new and are not SYN ###
rule2_drop_not_syn() {
	/sbin/iptables -t mangle -A PREROUTING -p tcp ! --syn -m conntrack --ctstate NEW -j DROP
}

#=================================
### 3: Drop SYN packets with suspicious MSS value ###
rule3_drop_suspcious_mss() {
	/sbin/iptables -t mangle -A PREROUTING -p tcp -m conntrack --ctstate NEW -m tcpmss ! --mss 536:65535 -j DROP
}

#=================================
### 4: Block packets with bogus TCP flags ###
rule4_drop_bogus_tcp() {
	/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
	/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
	/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
	/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
	/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,ACK FIN -j DROP
	/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,URG URG -j DROP
	/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,FIN FIN -j DROP
	/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,PSH PSH -j DROP
	/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL ALL -j DROP
	/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL NONE -j DROP
	/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL FIN,PSH,URG -j DROP
	/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,FIN,PSH,URG -j DROP
	/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP
}

#=================================
### 5: Block spoofed packets ###
rule5_drop_spoofed() {
	/sbin/iptables -t mangle -A PREROUTING -s 224.0.0.0/3 -j DROP
	/sbin/iptables -t mangle -A PREROUTING -s 169.254.0.0/16 -j DROP
	/sbin/iptables -t mangle -A PREROUTING -s 172.16.0.0/12 -j DROP
	/sbin/iptables -t mangle -A PREROUTING -s 192.0.2.0/24 -j DROP
	# /sbin/iptables -t mangle -A PREROUTING -s 192.168.0.0/16 -j DROP
	# /sbin/iptables -t mangle -A PREROUTING -s 10.0.0.0/8 -j DROP
	/sbin/iptables -t mangle -A PREROUTING -s 0.0.0.0/8 -j DROP
	/sbin/iptables -t mangle -A PREROUTING -s 240.0.0.0/5 -j DROP
	/sbin/iptables -t mangle -A PREROUTING -s 127.0.0.0/8 ! -i lo -j DROP
}

#=================================
### 6: Drop ICMP (you usually don't need this protocol) ###
rule6_drop_icmp() {
	/sbin/iptables -t mangle -A PREROUTING -p icmp -j DROP
	#/sbin/iptables -A INPUT -p icmp -m icmp --icmp-type 8 -j DROP
}

#=================================
### 7: Drop fragments in all chains ###
rule7_drop_fragments() {
	/sbin/iptables -t mangle -A PREROUTING -f -j DROP
}

#=================================
### 8: Limit connections per source IP ###
rule8_limit_connections() {
	[ -z "$1" ] && max_connection=111 || max_connection=$1
	/sbin/iptables -A INPUT -p tcp -m connlimit --connlimit-above $max_connection -j REJECT --reject-with tcp-reset
}

#=================================
### 9: Limit RST packets ###
rule9_limit_rst() {
	/sbin/iptables -A INPUT -p tcp --tcp-flags RST RST -m limit --limit 2/s --limit-burst 2 -j ACCEPT
	/sbin/iptables -A INPUT -p tcp --tcp-flags RST RST -j DROP
}

#=================================
### 10: Limit new TCP connections per second per source IP ###
rule10_limit_connections_per_sec_and_ip() {
	/sbin/iptables -A INPUT -p tcp -m conntrack --ctstate NEW -m limit --limit 60/s --limit-burst 20 -j ACCEPT
	/sbin/iptables -A INPUT -p tcp -m conntrack --ctstate NEW -j DROP
}

#=================================
### 11: Use SYNPROXY on all ports (disables connection limiting rule) ###
rule11_drop_invalid() {
	if [ ! -z "$1" ]; then 
		port=$1
		# port=80
		iptables -t raw -A PREROUTING -p tcp --dport $port -m tcp --syn -j CT --notrack
		iptables -A INPUT -p tcp --dport $port -m tcp -m conntrack --ctstate INVALID,UNTRACKED -j SYNPROXY --sack-perm --timestamp --wscale 7 --mss 1460

		# port=25565
		# iptables -t raw -A PREROUTING -p tcp --dport $port -m tcp --syn -j CT --notrack
		# iptables -A INPUT -p tcp --dport $port -m tcp -m conntrack --ctstate INVALID,UNTRACKED -j SYNPROXY --sack-perm --timestamp --wscale 7 --mss 1460
		
		[ -z "$drop_invalid_set" ] && echo drop invalid port $port ...
		[ -z "$drop_invalid_set" ] && iptables -A INPUT -m conntrack --ctstate INVALID -j DROP && drop_invalid_set=1
	fi
}

#monitor synproxy
#watch -n1 cat /proc/net/stat/synproxy

#=================================
### SSH brute-force protection ###
bouns1_drop_ssh_brutefore() {
	/sbin/iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --set
	/sbin/iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --update --seconds 60 --hitcount 10 -j DROP
}

#=================================
### Protection against port scanning ###
bouns2_drop_port_scan() {
	/sbin/iptables -N port-scanning
	/sbin/iptables -A port-scanning -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s --limit-burst 2 -j RETURN
	/sbin/iptables -A port-scanning -j DROP
}

if [ $(id -u) -ne 0 ]; then
    echo script is not run as root, exiting...
    exit
fi
	
rule_reset
rule1_drop_invalid
rule2_drop_not_syn
rule3_drop_suspcious_mss
rule4_drop_bogus_tcp
#rule5_drop_spoofed
rule6_drop_icmp
rule7_drop_fragments
rule8_limit_connections 111
rule9_limit_rst
rule10_limit_connections_per_sec_and_ip
rule11_drop_invalid 80
rule11_drop_invalid 25565
bouns1_drop_ssh_brutefore
bouns2_drop_port_scan
rule_dump

