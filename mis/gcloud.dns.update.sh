#!/bin/bash

ttlify() {
  local i
  for i in "$@"; do
    [[ "${i}" =~ ^([0-9]+)([a-z]*)$ ]] || continue
    local num="${BASH_REMATCH[1]}"
    local unit="${BASH_REMATCH[2]}"
    case "${unit}" in
                     weeks|week|wee|we|w) unit=''; num=$[num*60*60*24*7];;
                           days|day|da|d) unit=''; num=$[num*60*60*24];;
                     hours|hour|hou|ho|h) unit=''; num=$[num*60*60];;
      minutes|minute|minut|minu|min|mi|m) unit=''; num=$[num*60];;
      seconds|second|secon|seco|sec|se|s) unit=''; num=$[num];;
    esac
    echo "${num}${unit}"
  done
}

dns_start() {
  gcloud dns record-sets transaction start    -z "${ZONENAME}"
}

dns_info() {
  gcloud dns record-sets transaction describe -z "${ZONENAME}"
}

dns_abort() {
  gcloud dns record-sets transaction abort    -z "${ZONENAME}"
}

dns_commit() {
  gcloud dns record-sets transaction execute  -z "${ZONENAME}"
}

dns_add() {
  if [[ -n "$1" && "$1" != '@' ]]; then
    local -r name="$1.${ZONE}."
  else
    local -r name="${ZONE}."
  fi
  local -r ttl="$(ttlify "$2")"
  local -r type="$3"
  shift 3
  gcloud dns record-sets transaction add      -z "${ZONENAME}" --name "${name}" --ttl "${ttl}" --type "${type}" "$@"
}

dns_del() {
  if [[ -n "$1" && "$1" != '@' ]]; then
    local -r name="$1.${ZONE}."
  else
    local -r name="${ZONE}."
  fi
  local -r ttl="$(ttlify "$2")"
  local -r type="$3"
  shift 3
  gcloud dns record-sets transaction remove   -z "${ZONENAME}" --name "${name}" --ttl "${ttl}" --type "${type}" "$@"
}

lookup_dns_ip() {
  host "$1" | sed -rn 's@^.* has address @@p'
}

lookup_dns_cname() {
  host "$1" | sed -rn 's@^.* an alias for @@p'
}

my_ip() {
  # ip -4 addr show dev eth0 | sed -rn 's@^    inet ([0-9.]+).*@\1@p'
  curl https://api.ipify.org
}

update_A() {
  ZONENAME=$1
  ZONE=$2
  HOST=$3
  TTL=$4
  dns_start
  dns_del ${HOST} ${TTL} A `lookup_dns_ip "${HOST}.${ZONE}."`
  dns_add ${HOST} ${TTL} A `my_ip`
  dns_commit
}

update_CNAME() {
  ZONENAME=$1
  ZONE=$2
  HOST=$3
  TTL=$4
  CNAME=$5
  dns_start
  dns_del ${HOST} ${TTL} CNAME `lookup_dns_cname "${HOST}.${ZONE}."`
  dns_add ${HOST} ${TTL} CNAME ${CNAME}
  dns_commit
}

case "$1" in
  A)
	# update_A foo-bar-com foo.bar.com my-vm 5min
    update_A $2 $3 $4 $5
    exit
    ;;
  CNAME)
    update_CNAME $2 $3 $4 $5 $6
    exit
    ;;
  *)
	echo "Usage: $0 {A|CNAME}"
	exit 1
	;;
esac
