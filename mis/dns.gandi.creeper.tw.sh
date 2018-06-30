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

DOMAIN="creeper.tw"
APIKEY="yVXgU0px5mvrLg7rFjU6AN5Q"
TTL=300

DIR=$(readlink -e "$0")
DP0=$(dirname "$DIR")
. $DP0/dns.gandi.update.sh $*
