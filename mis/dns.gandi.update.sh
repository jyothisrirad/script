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

# DOMAIN="yozliu.pw"
# RECORD="mywanip"
# APIKEY="U13GATFwOKseWwgzF5cAjDkT"


API="https://dns.api.gandi.net/api/v5/"
IP_SERVICE="http://me.gandi.net"

# IP4=$(curl -s4 $IP_SERVICE)
# IP6=$(curl -s6 $IP_SERVICE)

# dns_status() {
	# if [[ -z "$IP4" && -z "$IP6" ]]; then
		# echo "Something went wrong. Can not get your IP from $IP_SERVICE "
		# exit 1
	# fi
# }

# dns_put_a() {
	# if [[ ! -z "$IP4" ]]; then
		# DATA='{"rrset_values": ["'$IP4'","192.168.1.1"],"rrset_ttl": 300}'
		# echo $DATA
		# curl -s -XPUT -d "$DATA" \
			# -H"X-Api-Key: $APIKEY" \
			# -H"Content-Type: application/json" \
			# "$API/domains/$DOMAIN/records/$RECORD/A"
	# fi
# }

dns_put_a_json() {
	RECORD="$1"
    # echo $2
    DATA='{"rrset_values": '$2',"rrset_ttl": '$TTL'}'
    # echo $DATA
    curl -s -XPUT -d "$DATA" \
        -H"X-Api-Key: $APIKEY" \
        -H"Content-Type: application/json" \
        "$API/domains/$DOMAIN/records/$RECORD/A"
}

dns_get_a() {
	RECORD="$1"
	# echo API=$API
	# echo DOMAIN=$DOMAIN
	# echo RECORD=$RECORD
	curl -s -XGET \
		-H"X-Api-Key: $APIKEY" \
		"$API/domains/$DOMAIN/records/$RECORD/A"
}

# dns_delete_a() {
	# if [[ ! -z "$IP4" ]]; then
		# DATA='{"rrset_values": ["'$IP4'"],"rrset_ttl": 300}'
		## DATA='{"rrset_values": ["'"192.168.1.1"'"]}'
		# curl -s -XDELETE -d "$DATA" \
			# -H"X-Api-Key: $APIKEY" \
			# -H"Content-Type: application/json" \
			# "$API/domains/$DOMAIN/records/$RECORD/A"
	# fi
# }

dns_delete_a() {
	RECORD="$1"
    curl -s -XDELETE \
        -H"X-Api-Key: $APIKEY" \
        "$API/domains/$DOMAIN/records/$RECORD/A"
}

# dnsv6_put_a() {
	# if [[ ! -z "$IP6" ]]; then
		# DATA='{"rrset_values": ["'$IP6'"]}'
		# curl -s -XPUT -d "$DATA" \
			# -H"X-Api-Key: $APIKEY" \
			# -H"Content-Type: application/json" \
			# "$API/domains/$DOMAIN/records/$RECORD/AAAA"
	# fi
# }

# dns_get_a | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" 
# dns_put_a
# dns_delete_a

case "$1" in
  append)
	# add single ip
    RECORD=$2
    appendip=$3
    arr=( $(dns_get_a $RECORD | jq -r '.rrset_values' | sed 's/null//' | tr -d '[],\"') )
    printf '%s\n' "${arr[@]}" | grep -q $appendip && echo IP existed already, Quitting && exit
    arr+=("$appendip")
    json=$(printf '%s\n' "${arr[@]}" | jq -R . | jq -s . | tr -d '\n' | sed 's/"",//')
    # echo json=$json
    dns_put_a_json $RECORD "$json"
    exit
    ;;
  remove)
	# remove single ip
    RECORD=$2
    deleteip=$3
    arr=( $(dns_get_a $RECORD | jq -r '.rrset_values' | sed 's/null//' | tr -d '[],\"') )
    json=$(printf '%s\n' "${arr[@]/$deleteip}" | jq -R . | jq -s . | tr -d '\n' | sed 's/"",//' | sed 's/""//')
    # echo json=$json
    dns_put_a_json $RECORD "$json"
    exit
    ;;
  set)
	# set multiple ips
    RECORD=$2
	shift 2
    arr=( $* )
	
	newip=${arr[@]}
	
	oldip=$(dns_get_a $RECORD | jq -r '.rrset_values' | tr -d '[],\" ' | sed '/^\s*$/d' | sort -u | tr '\n' ' ' | awk '{$1=$1;print}')
	[ "$oldip" == "$newip" ] && echo IPs set already, Quitting && exit
	
	# echo oldip=$oldip
	# echo arr=${arr[@]}
	
    json=$(printf '%s\n' "${arr[@]/$deleteip}" | jq -R . | jq -s . | tr -d '\n' | sed 's/"",//')
    # echo json=$json
	dns_put_a_json $RECORD "$json"
    exit
    ;;
  del)
	# del whole record
    RECORD=$2
	dns_delete_a $RECORD
    exit
    ;;
  query)
	# get current ips
    RECORD=$2
	dns_get_a $RECORD | jq -r '.rrset_values' | tr -d '[],\" ' | sed '/^\s*$/d'
    exit
    ;;
esac
