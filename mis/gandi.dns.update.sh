#!/bin/bash
# 
# Updates a zone record using Gandi's LiveDNS.
# Ideally this script is placed into a crontab or when the WAN interface comes up.
# Replace APIKEY with your Gandi API Key and DOMAIN with your domain name at Gandi.
# Set RECORD to which zone label you wish to update.
# You will be able to query mywanip.example.net if everything went successful.
# 
# Live dns is available on www.gandi.net
# Obtaining your API Key: http://doc.livedns.gandi.net/#step-1-get-your-api-key
#

DOMAIN="yozliu.pw"
RECORD="mywanip"
APIKEY="U13GATFwOKseWwgzF5cAjDkT"


API="https://dns.api.gandi.net/api/v5/"
IP_SERVICE="http://me.gandi.net"

IP4=$(curl -s4 $IP_SERVICE)
IP6=$(curl -s6 $IP_SERVICE)

dns_status() {
	if [[ -z "$IP4" && -z "$IP6" ]]; then
		echo "Something went wrong. Can not get your IP from $IP_SERVICE "
		exit 1
	fi
}

dns_put_a() {
	if [[ ! -z "$IP4" ]]; then
		DATA='{"rrset_values": ["'$IP4'","192.168.1.1"],"rrset_ttl": 300}'
		echo $DATA
		curl -s -XPUT -d "$DATA" \
			-H"X-Api-Key: $APIKEY" \
			-H"Content-Type: application/json" \
			"$API/domains/$DOMAIN/records/$RECORD/A"
	fi
}

dns_get_a() {
	curl -s -XGET \
		-H"X-Api-Key: $APIKEY" \
		"$API/domains/$DOMAIN/records/$RECORD/A"
}

dns_delete_a() {
	if [[ ! -z "$IP4" ]]; then
		DATA='{"rrset_values": ["'$IP4'"],"rrset_ttl": 300}'
		# DATA='{"rrset_values": ["'"192.168.1.1"'"]}'
		curl -s -XDELETE -d "$DATA" \
			-H"X-Api-Key: $APIKEY" \
			-H"Content-Type: application/json" \
			"$API/domains/$DOMAIN/records/$RECORD/A"
	fi
}

dnsv6_put_a() {
	if [[ ! -z "$IP6" ]]; then
		DATA='{"rrset_values": ["'$IP6'"]}'
		curl -s -XPUT -d "$DATA" \
			-H"X-Api-Key: $APIKEY" \
			-H"Content-Type: application/json" \
			"$API/domains/$DOMAIN/records/$RECORD/AAAA"
	fi
}

dns_get_a | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" 
# dns_put_a
# dns_delete_a
