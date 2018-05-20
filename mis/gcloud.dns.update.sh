#!/bin/bash

. /home/sita/script/include/console.color

PROJECT=creeper-196707

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
  echo -e gcloud dns record-sets transaction ${GREEN}start${NC} -z "${ZONENAME}" --project $PROJECT
  gcloud dns record-sets transaction start    -z "${ZONENAME}" --project $PROJECT
}

dns_info() {
  echo -e gcloud dns record-sets transaction ${GREEN}describe${NC} -z "${ZONENAME}" --project $PROJECT
  gcloud dns record-sets transaction describe -z "${ZONENAME}" --project $PROJECT
}

dns_abort() {
  echo -e gcloud dns record-sets transaction ${GREEN}abort${NC} -z "${ZONENAME}" --project $PROJECT
  gcloud dns record-sets transaction abort    -z "${ZONENAME}" --project $PROJECT
}

dns_commit() {
  echo -e gcloud dns record-sets transaction ${GREEN}execute${NC} -z "${ZONENAME}" --project $PROJECT
  gcloud dns record-sets transaction execute  -z "${ZONENAME}" --project $PROJECT
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
  echo -e gcloud dns record-sets transaction ${GREEN}add${NC} -z "${ZONENAME}" --name "${name}" --ttl ${GREEN}"${ttl}"${NC} --type ${GREEN}"${type}" "$@"${NC} --project $PROJECT 
  gcloud dns record-sets transaction add      -z "${ZONENAME}" --name "${name}" --ttl "${ttl}" --type "${type}" "$@" --project $PROJECT
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
  echo -e gcloud dns record-sets transaction ${GREEN}remove${NC} -z "${ZONENAME}" --name "${name}" --ttl ${GREEN}"${ttl}"${NC} --type ${GREEN}"${type}" "$@"${NC} --project $PROJECT 
  gcloud dns record-sets transaction remove   -z "${ZONENAME}" --name "${name}" --ttl "${ttl}" --type "${type}" "$@" --project $PROJECT
}

lookup_dns_ip() {
  host "$1" | sed -rn 's@^.* has address @@p'
}

lookup_dns_cname() {
  host "$1" | sed -rn 's@^.* an alias for @@p'
}

my_ip() {
  # ip -4 addr show dev eth0 | sed -rn 's@^    inet ([0-9.]+).*@\1@p'
  # curl https://api.ipify.org
  curl -s https://api.ipify.org
}

update_A() {
  ZONENAME=$1
  HOST=$2
  ZONE=$3
  TTL1=$4
  TTL2=$5
  if [[ -n "$1" && "${HOST}" != '@' ]]; then
    local -r name="${HOST}.${ZONE}."
  else
    local -r name="${ZONE}."
  fi
  shift 5
  [ ! -z "$1" ] && newip=$* || newip=$(my_ip) 
  [ "$(lookup_dns_ip "$name" | tr '\n' ' ' | sed -e 's/[[:space:]]*$//')" == "$newip" ] && echo -e ${YELLOW}"$name" IN A $newip${GREEN}, DNS record already the same, skipping ...${NC} && return
  # dns_start
  dns_del ${HOST} ${TTL1} A `lookup_dns_ip "$name"`
  dns_del ${HOST} ${TTL2} A `lookup_dns_ip "$name"`
  dns_add ${HOST} ${TTL2} A $newip
  # dns_commit
}

update_CNAME() {
  ZONENAME=$1
  HOST=$2
  ZONE=$3
  CNAME=$4
  TTL1=$5
  TTL2=$6
  [ $(lookup_dns_cname "${HOST}.${ZONE}.") == ${CNAME} ] && echo -e ${YELLOW}"${HOST}.${ZONE}." IN CNAME ${CNAME}${GREEN}, DNS record already the same, skipping ...${NC} && return
  # dns_start
  dns_del ${HOST} ${TTL1} CNAME `lookup_dns_cname "${HOST}.${ZONE}."`
  dns_del ${HOST} ${TTL2} CNAME `lookup_dns_cname "${HOST}.${ZONE}."`
  dns_add ${HOST} ${TTL2} CNAME ${CNAME}
  # dns_commit
}

pushd "/tmp" >/dev/null
case "$1" in
  A)
	# update_A foo-bar-com foo.bar.com my-vm 5min 5min [newip..]
    shift 1
    update_A $*
    exit
    ;;
    
  CNAME)
	# update_CNAME foo-bar-com foo bar.com my-vm.bar.com 5min 5min
    shift 1
    update_CNAME $*
    exit
    ;;
    
  add)
	# add creeper-196707 foo-bar-com foo bar.com 5min A 1.2.3.4
    PROJECT=$2
    ZONENAME=$3
    ZONE=$5
    HOST=$4
    TTL=$6
    TTL2=$7
    TYPE=$8
    shift 8
    # dns_start
    dns_add ${HOST} ${TTL2} ${TYPE} $@
    # dns_commit
    exit
    ;;
    
  del)
	# del creeper-196707 foo-bar-com foo bar.com 5min A
    PROJECT=$2
    ZONENAME=$3
    ZONE=$5
    HOST=$4
    TTL=$6
    TTL2=$7
    TYPE=$8
    shift 8
    # dns_start
    ip=$(echo `lookup_dns_ip "${HOST}.${ZONE}."` | tr ' ' '\n' | sort -u | tr '\n' ' ')
    dns_del ${HOST} ${TTL} ${TYPE} $ip
    dns_del ${HOST} ${TTL2} ${TYPE} $ip
    # dns_commit
    # dns_del ${HOST} ${TTL} ${TYPE} $@
    exit
    ;;
    
  start)
    PROJECT=$2
    ZONENAME=$3
    dns_start
    exit
    ;;
    
  info)
    PROJECT=$2
    ZONENAME=$3
    dns_info
    exit
    ;;
    
  abort)
    PROJECT=$2
    ZONENAME=$3
    dns_abort
    exit
    ;;
    
  commit)
    PROJECT=$2
    ZONENAME=$3
    dns_commit
    exit
    ;;
    
  append)
    PROJECT=$2
    ZONENAME=$3
    ZONE=$5
    HOST=$4
    TTL=$6
    TTL2=$7
    TYPE=$8
    
    ip=$(echo `lookup_dns_ip "${HOST}.${ZONE}."` | tr ' ' '\n' | sort -u | tr '\n' ' ')
    newip=$(echo `lookup_dns_ip "${HOST}.${ZONE}."` | tr ' ' '\n' | sort -u | tr '\n' ' ')
    # echo $ip
    newip+=" `my_ip`"
    newip=$(echo "${newip[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')
    # echo $newip
    
    # dns_start
    dns_del ${HOST} ${TTL} ${TYPE} $ip
    dns_del ${HOST} ${TTL2} ${TYPE} $ip
    dns_add ${HOST} ${TTL2} ${TYPE} $newip
    # dns_commit
    ;;
    
  remove)
    PROJECT=$2
    ZONENAME=$3
    ZONE=$5
    HOST=$4
    TTL=$6
    TTL2=$7
    TYPE=$8
    
    ip=$(echo `lookup_dns_ip "${HOST}.${ZONE}."` | tr ' ' '\n' | sort -u | tr '\n' ' ')
    # echo $ip
    delete=`my_ip`
    # delete=2.2.2.2
    newip=$(echo ${ip[@]/$delete})
    # echo $newip
    
    # dns_start
    dns_del ${HOST} ${TTL} ${TYPE} $ip
    dns_del ${HOST} ${TTL2} ${TYPE} $ip
    dns_add ${HOST} ${TTL2} ${TYPE} $newip
    # dns_commit
    ;;
    
  *)
	echo "Usage: $0 {A|CNAME|add|del}"
	exit 1
	;;
    
esac
