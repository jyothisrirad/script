#!/bin/bash

#=================================
IPLOG=1

#=================================
check_root_access() {
	if [ $(id -u) -ne 0 ]; then
		echo script is not run as root, exiting...
		exit
	fi
}

#=================================
rule_reset() {
	/sbin/iptables -F
	/sbin/iptables -X
	/sbin/iptables -t nat -F
	/sbin/iptables -t nat -X
	/sbin/iptables -t mangle -F
	/sbin/iptables -t mangle -X
	/sbin/iptables -t raw -F
	/sbin/iptables -t raw -X
	/sbin/iptables -t security -F
	/sbin/iptables -t security -X
}

#=================================
rule_dump() {
	iptables-save
}

#=================================
### 1: Drop invalid packets ###
# not working with rule 11
rule1_drop_invalid() {
	[ ! -z "$IPLOG" ] && /sbin/iptables -t mangle -A PREROUTING -m conntrack --ctstate INVALID -j LOG --log-prefix "rule1_drop_invalid: "
	/sbin/iptables -t mangle -A PREROUTING -m conntrack --ctstate INVALID -j DROP
}

#=================================
### 2: Drop TCP packets that are new and are not SYN ###
rule2_drop_not_syn() {
	[ ! -z "$IPLOG" ] && /sbin/iptables -t mangle -A PREROUTING -p tcp ! --syn -m conntrack --ctstate NEW -j LOG --log-prefix "rule2_drop_not_syn: "
	/sbin/iptables -t mangle -A PREROUTING -p tcp ! --syn -m conntrack --ctstate NEW -j DROP
}

#=================================
### 3: Drop SYN packets with suspicious MSS value ###
rule3_drop_suspcious_mss() {
	[ ! -z "$IPLOG" ] && /sbin/iptables -t mangle -A PREROUTING -p tcp -m conntrack --ctstate NEW -m tcpmss ! --mss 536:65535 -j LOG --log-prefix "rule3_drop_suspcious_mss: "
	/sbin/iptables -t mangle -A PREROUTING -p tcp -m conntrack --ctstate NEW -m tcpmss ! --mss 536:65535 -j DROP
}

#=================================
### 4: Block packets with bogus TCP flags ###
rule4_drop_bogus_tcp() {

	[ ! -z "$IPLOG" ] && /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j LOG --log-prefix "rule4_drop_bogus_tcp NONE: "
	/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP

	[ ! -z "$IPLOG" ] && /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN FIN,SYN -j LOG --log-prefix "rule4_drop_bogus_tcp SYN: "
	/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN FIN,SYN -j DROP

	[ ! -z "$IPLOG" ] && /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags SYN,RST SYN,RST -j LOG --log-prefix "rule4_drop_bogus_tcp RST: "
	/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags SYN,RST SYN,RST -j DROP

	[ ! -z "$IPLOG" ] && /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,RST FIN,RST -j LOG --log-prefix "rule4_drop_bogus_tcp RST: "
	/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,RST FIN,RST -j DROP

	[ ! -z "$IPLOG" ] && /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,ACK FIN -j LOG --log-prefix "rule4_drop_bogus_tcp FIN: "
	/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,ACK FIN -j DROP

	[ ! -z "$IPLOG" ] && /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,URG URG -j LOG --log-prefix "rule4_drop_bogus_tcp URG: "
	/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,URG URG -j DROP

	[ ! -z "$IPLOG" ] && /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,FIN FIN -j LOG --log-prefix "rule4_drop_bogus_tcp FIN: "
	/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,FIN FIN -j DROP

	[ ! -z "$IPLOG" ] && /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,PSH PSH -j LOG --log-prefix "rule4_drop_bogus_tcp PSH: "
	/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,PSH PSH -j DROP

	[ ! -z "$IPLOG" ] && /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL ALL -j LOG --log-prefix "rule4_drop_bogus_tcp ALL: "
	/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL ALL -j DROP

	[ ! -z "$IPLOG" ] && /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL NONE -j LOG --log-prefix "rule4_drop_bogus_tcp NONE: "
	/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL NONE -j DROP

	[ ! -z "$IPLOG" ] && /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL FIN,PSH,URG -j LOG --log-prefix "rule4_drop_bogus_tcp URG: "
	/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL FIN,PSH,URG -j DROP

	[ ! -z "$IPLOG" ] && /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,FIN,PSH,URG -j LOG --log-prefix "rule4_drop_bogus_tcp URG: "
	/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,FIN,PSH,URG -j DROP

	[ ! -z "$IPLOG" ] && /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j LOG --log-prefix "rule4_drop_bogus_tcp URG: "
	/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP
}

#=================================
### 5: Block spoofed packets ###
rule5_drop_spoofed() {
	[ ! -z "$IPLOG" ] && /sbin/iptables -t mangle -A PREROUTING -s 224.0.0.0/3 -j LOG --log-prefix "rule5_drop_spoofed 224: "
	/sbin/iptables -t mangle -A PREROUTING -s 224.0.0.0/3 -j DROP
	
	[ ! -z "$IPLOG" ] && /sbin/iptables -t mangle -A PREROUTING -s 169.254.0.0/16 -j LOG --log-prefix "rule5_drop_spoofed 169: "
	/sbin/iptables -t mangle -A PREROUTING -s 169.254.0.0/16 -j DROP
	
	[ ! -z "$IPLOG" ] && /sbin/iptables -t mangle -A PREROUTING -s 172.16.0.0/12 -j LOG --log-prefix "rule5_drop_spoofed 172: "
	/sbin/iptables -t mangle -A PREROUTING -s 172.16.0.0/12 -j DROP
	
	[ ! -z "$IPLOG" ] && /sbin/iptables -t mangle -A PREROUTING -s 192.0.2.0/24 -j LOG --log-prefix "rule5_drop_spoofed 192: "
	/sbin/iptables -t mangle -A PREROUTING -s 192.0.2.0/24 -j DROP
	
	# [ ! -z "$IPLOG" ] && /sbin/iptables -t mangle -A PREROUTING -s 192.168.0.0/16 -j LOG --log-prefix "rule5_drop_spoofed 192: "
	# /sbin/iptables -t mangle -A PREROUTING -s 192.168.0.0/16 -j DROP
	
	# [ ! -z "$IPLOG" ] && /sbin/iptables -t mangle -A PREROUTING -s 10.0.0.0/8 -j LOG --log-prefix "rule5_drop_spoofed 10: "
	# /sbin/iptables -t mangle -A PREROUTING -s 10.0.0.0/8 -j DROP
	
	[ ! -z "$IPLOG" ] && /sbin/iptables -t mangle -A PREROUTING -s 0.0.0.0/8 -j LOG --log-prefix "rule5_drop_spoofed 0: "
	/sbin/iptables -t mangle -A PREROUTING -s 0.0.0.0/8 -j DROP
	
	[ ! -z "$IPLOG" ] && /sbin/iptables -t mangle -A PREROUTING -s 240.0.0.0/5 -j LOG --log-prefix "rule5_drop_spoofed 240: "
	/sbin/iptables -t mangle -A PREROUTING -s 240.0.0.0/5 -j DROP
	
	[ ! -z "$IPLOG" ] && /sbin/iptables -t mangle -A PREROUTING -s 127.0.0.0/8 -j LOG --log-prefix "rule5_drop_spoofed 127: "
	/sbin/iptables -t mangle -A PREROUTING -s 127.0.0.0/8 ! -i lo -j DROP
}

#=================================
### 6: Drop ICMP (you usually don't need this protocol) ###
rule6_drop_icmp() {
	[ ! -z "$IPLOG" ] && /sbin/iptables -t mangle -A PREROUTING -p icmp -j LOG --log-prefix "rule6_drop_icmp: "
	/sbin/iptables -t mangle -A PREROUTING -p icmp -j DROP
	#/sbin/iptables -A INPUT -p icmp -m icmp --icmp-type 8 -j DROP
}

#=================================
### 7: Drop fragments in all chains ###
rule7_drop_fragments() {
	[ ! -z "$IPLOG" ] && /sbin/iptables -t mangle -A PREROUTING -f -j LOG --log-prefix "rule7_drop_fragments: "
	/sbin/iptables -t mangle -A PREROUTING -f -j DROP
}

#=================================
### 8: Limit connections per source IP ###
rule8_limit_connections() {
	[ -z "$1" ] && max_connection=80 || max_connection=$1
	[ ! -z "$IPLOG" ] && /sbin/iptables -A INPUT -p tcp -m connlimit --connlimit-above $max_connection -j LOG --log-prefix "rule8_limit_connections: "
	/sbin/iptables -A INPUT -p tcp -m connlimit --connlimit-above $max_connection -j REJECT --reject-with tcp-reset
	# /sbin/iptables -I INPUT -p tcp --syn --dport 80 -m connlimit --connlimit-above 20 -j REJECT --reject-with tcp-reset
}

#=================================
### 9: Limit RST packets ###
rule9_limit_rst() {
	/sbin/iptables -A INPUT -p tcp --tcp-flags RST RST -m limit --limit 2/s --limit-burst 2 -j ACCEPT
	# [ ! -z "$IPLOG" ] && /sbin/iptables -A INPUT -p tcp --tcp-flags RST RST -j LOG --log-prefix "rule9_limit_rst: "
	/sbin/iptables -A INPUT -p tcp --tcp-flags RST RST -j DROP
}

#=================================
### 10: Limit new TCP connections per second per source IP ###
rule10_limit_connections_per_sec_and_ip() {
	/sbin/iptables -A INPUT -p tcp -m conntrack --ctstate NEW -m limit --limit 60/s --limit-burst 20 -j ACCEPT
	[ ! -z "$IPLOG" ] && /sbin/iptables -A INPUT -p tcp -m conntrack --ctstate NEW -j LOG --log-prefix "rule10_limit_connections_per_sec_and_ip: "
	/sbin/iptables -A INPUT -p tcp -m conntrack --ctstate NEW -j DROP
}

#=================================
### 11: Use SYNPROXY on all ports (disables connection limiting rule) ###
# not working with rule 1
# against SYN Flood, Transport (4)
rule11_synproxy() {
	if [ ! -z "$1" ]; then 
		PORT=$1
		
		/sbin/iptables -t raw -A PREROUTING -p tcp --dport $PORT -m tcp --syn -j CT --notrack
		
		/sbin/iptables -A INPUT -p tcp --dport $PORT -m tcp -m conntrack --ctstate INVALID,UNTRACKED -j SYNPROXY --sack-perm --timestamp --wscale 7 --mss 1460

		[ ! -z "$IPLOG" ] && /sbin/iptables -A INPUT -p tcp --dport $PORT -m conntrack --ctstate INVALID -j LOG --log-prefix "rule11_synproxy: "
		/sbin/iptables -A INPUT -p tcp --dport $PORT -m conntrack --ctstate INVALID -j DROP
	fi
}

#=================================
rule11_drop_invalid_fix() {
	[ ! -z "$IPLOG" ] && /sbin/iptables -A INPUT -m conntrack --ctstate INVALID -j LOG --log-prefix "rule11_drop_invalid_fix: "
	/sbin/iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
	
	# replace rule 1
	# /sbin/iptables -A INPUT -p tcp -m state --state INVALID -j DROP
}

#=================================
### SSH brute-force protection ###
bouns1_drop_ssh_brutefore() {
	/sbin/iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --set
	[ ! -z "$IPLOG" ] && /sbin/iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --update --seconds 60 --hitcount 10 -j LOG --log-prefix "bouns1_drop_ssh_brutefore: "
	/sbin/iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --update --seconds 60 --hitcount 10 -j DROP
}

#=================================
### Protection against port scanning ###
bouns2_drop_port_scan() {
	/sbin/iptables -N port-scanning
	/sbin/iptables -A port-scanning -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s --limit-burst 2 -j RETURN
	[ ! -z "$IPLOG" ] && /sbin/iptables -A port-scanning -j LOG --log-prefix "bouns2_drop_port_scan: "
	/sbin/iptables -A port-scanning -j DROP
}

#=================================
rule_slowloris() {
	# Firstly, what with the reason Minecraft slowloris exploit, there's a nice little iptables rule here that can prevent this being used:
	# What this basically does is, if someone tries to connect to your server 20 times from the same IP simultaneously within 5 seconds, it'll simply drop the new connections until the old ones are cleared up.
	sudo /sbin/iptables -I INPUT -p tcp --dport 25565 -m state --state NEW -m recent --set
	[ ! -z "$IPLOG" ] && /sbin/iptables -I INPUT -p tcp --dport 25565 -m state --state NEW -m recent --update --seconds 5 --hitcount 20 -j LOG --log-prefix "rule_slowloris: "
	sudo /sbin/iptables -I INPUT -p tcp --dport 25565 -m state --state NEW -m recent --update --seconds 5 --hitcount 20 -j DROP

}

#=================================
rule_portscanning() {
	# Fail2ban to handle bruteforcers and for portscanning just do
	[ ! -z "$IPLOG" ] && /sbin/iptables -A INPUT -m recent --name portscan --rcheck --seconds 172800 -j LOG --log-prefix "rule_portscanning: "
	/sbin/iptables -A INPUT -m recent --name portscan --rcheck --seconds 172800 -j DROP
	/sbin/iptables -A INPUT -m recent --name portscan --remove
	
	/sbin/iptables -A INPUT -p tcp -m tcp --dport 139 -m recent --name portscan --set -j LOG --log-prefix "Portscaner:"
	/sbin/iptables -A INPUT -p tcp -m tcp --dport 139 -m recent --name portscan --set -j DROP
}

#=================================
rules_enable() {
	rule_reset
	# rule1_drop_invalid
	rule2_drop_not_syn
	rule3_drop_suspcious_mss
	rule4_drop_bogus_tcp
	#rule5_drop_spoofed
	rule6_drop_icmp
	rule7_drop_fragments
	rule8_limit_connections 111
	rule9_limit_rst
	rule10_limit_connections_per_sec_and_ip
	rule11_synproxy 80
	rule11_synproxy 443
	rule11_synproxy 25565
	rule11_drop_invalid_fix
	bouns1_drop_ssh_brutefore
	bouns2_drop_port_scan
	rule_slowloris
	# rule_portscanning
	rule_dump
}

#=================================
check_root_access

case "$1" in
  enable)
	rules_enable
    exit
    ;;
  disable)
	rule_reset
    exit
	;;
  *)
  rules_enable
esac
