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

API="https://dns.api.gandi.net/api/v5/"
IP_SERVICE="http://me.gandi.net"

dns_get_a() {
	RECORD="$1"
	# echo API=$API
	# echo DOMAIN=$DOMAIN
	# echo RECORD=$RECORD
	curl -s -XGET \
		-H"X-Api-Key: $APIKEY" \
		"$API/domains/$DOMAIN/records/$RECORD/A"
}

dns_get_srv() {
	RECORD="$1"
	curl -s -XGET \
		-H"X-Api-Key: $APIKEY" \
		"$API/domains/$DOMAIN/records/$RECORD/SRV"
}

dns_put_a_json() {
	RECORD="$1"
    # echo $2
    DATA='{"rrset_values": '$2',"rrset_ttl": '$TTL'}'
    # echo $DATA
    curl -s -XPUT -d "$DATA" \
        -H"X-Api-Key: $APIKEY" \
        -H"Content-Type: application/json" \
        "$API/domains/$DOMAIN/records/$RECORD/A"
	echo
}

dns_put_srv_json() {
	RECORD="$1"
    echo $2
    DATA='{"rrset_values": '$2',"rrset_ttl": '$TTL'}'
    echo $DATA
    curl -s -XPUT -d "$DATA" \
        -H"X-Api-Key: $APIKEY" \
        -H"Content-Type: application/json" \
        "$API/domains/$DOMAIN/records/$RECORD/SRV"
	echo
}

dns_delete_a() {
	RECORD="$1"
    curl -s -XDELETE \
        -H"X-Api-Key: $APIKEY" \
        "$API/domains/$DOMAIN/records/$RECORD/A"
	echo
}

dns_delete_srv() {
	RECORD="$1"
    curl -s -XDELETE \
        -H"X-Api-Key: $APIKEY" \
        "$API/domains/$DOMAIN/records/$RECORD/SRV"
	echo
}

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
	# echo arr=${arr[@]}
    json=$(printf '%s\n' "${arr[@]/$deleteip}" | sed '/^\s*$/d' | jq -R . | jq -s . | tr -d '\n' | sed 's/"",//' | sed 's/""//')
    # echo json=$json
    dns_put_a_json $RECORD "$json"
    exit
    ;;
  set)
	# set multiple ips
    RECORD=$2
	shift 2
    arr=( $* )
	
	# echo RECORD=$RECORD
	
	newip=${arr[@]}
	
	[ -z "$newip" ] && echo IPs set empty, Quitting && exit
	
	# echo $(dns_get_a $RECORD)
	
	oldip=$(dns_get_a $RECORD | jq -r '.rrset_values' | tr -d '[],\" ' | sed '/^\s*$/d' | sort -u | tr '\n' ' ' | awk '{$1=$1;print}')
	[ "$oldip" == "$newip" ] && echo IPs set already, Quitting && exit
	
	# echo oldip=$oldip
	# echo arr=${arr[@]}
	
    json=$(printf '%s\n' "${arr[@]/$deleteip}" | jq -R . | jq -s . | tr -d '\n' | sed 's/"",//')
    # echo json=$json
	[ ! -z "$newip" ] && dns_put_a_json $RECORD "$json"
	# [ -z "$newip" ] && dns_delete_a $RECORD
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
  srvquery)
	# get current ips
    RECORD=$2
	dns_get_srv $RECORD | jq -r '.rrset_values' | tr -d '[],\"' | sed '/^\s*$/d' | sed 's/^\s*//g'
    exit
    ;;
  srvdel)
	# del whole record
    RECORD=$2
	dns_delete_srv $RECORD
    exit
    ;;
  srvset)
    RECORD=$2
	PRIORITY=$3
	WEIGHT=$4
	PORT=$5
	TARGET=$6
	dns_put_srv_json $RECORD "[ \"$PRIORITY $WEIGHT $PORT $TARGET\" ]"
    exit
    ;;
esac
