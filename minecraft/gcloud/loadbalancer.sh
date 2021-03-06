#!/bin/bash

###
. /home/sita/script/include/common_helper
. /home/sita/script/include/console.color
. /home/sita/script/include/gcloud_helper

###
dnsupdate=/home/sita/script/mis/gcloud.dns.update.sh
runscreen=/home/sita/script/mis/run_in_screen.sh
[ -z "$igctrl" ] && igctrl=/home/sita/script/minecraft/gcloud/igroup.sh

###
default_account=$(get_account)

# [ -z "$dns_account" ] && dns_account=chsliu@gmail.com
# [ -z "$dns_project" ] && dns_project=creeper-196707
[ -z "$dns_account" ] && dns_account=sita@changen.com.tw
[ -z "$dns_project" ] && dns_project=creeper-199909

[ -z "$lb_account" ] && lb_account=sita@changen.com.tw
[ -z "$PROJECT" ] && PROJECT=creeper-199909
[ -z "$REGION" ] && REGION=asia-east1
[ -z "$POOL" ] && POOL=lb
[ -z "$LB" ] && LB=$POOL
# [ -z "$instances_group" ] && instances_group=bc
[ -z "$instances_group_region" ] && instances_group_region=bc2
[ -z "$RULE" ] && RULE=minecraft
[ -z "$PROTO" ] && PROTO=TCP
[ -z "$PORT" ] && PORT=25565
[ -z "$default_HOST" ] && default_HOST=tp1

# echo lb_account=$lb_account
# echo PROJECT=$PROJECT
# echo POOL=$POOL
# echo LB=$LB
# echo instances_group_region=$instances_group_region
# echo igctrl=$igctrl
# exit

lookup_dns_ip() {
    host "$1" | sed -rn 's@^.* has address @@p'
}

lookup_lb_ip() {
    last_account=$(get_account)
    set_account $lb_account
    
    gcloud --project $PROJECT compute forwarding-rules list | grep $RULE | awk '{ printf ("%s\n", $3) }'
    
    set_account $last_account
}

is_load_balancer_already_start() {
    dnsip=$(lookup_dns_ip $LB.creeper.tw)
    lbip=$(lookup_lb_ip)
    # Checking if Load Balancer already started
    echo -e ${YELLOW}=== Load Balancer Status: ${GREEN}DNS=$dnsip,IP=$lbip ${NC}
    [ -z "$dnsip" ] && return 1
    [ "$dnsip" == "$lbip" ]
    return $?
}

###
start() {
    set_account $lb_account
        
    if ! is_load_balancer_already_start; then
        
        $igctrl start
    
        # Create Load Balancer
        echo -e ${GREEN}=== Create Load Balancer: ${YELLOW}$POOL ${NC}
        gcloud --project $PROJECT compute target-pools create $POOL --region $REGION

        # Attach instance-groups
        # echo -e ${GREEN}=== Attach instance-groups: ${YELLOW}$instances_group ${NC}
        # gcloud --project $PROJECT compute instance-groups managed set-target-pools $instances_group --target-pools $POOL

        # Attach regional instance-groups
        echo -e ${GREEN}=== Attach regional instance-groups: ${YELLOW}$instances_group_region to $POOL ${NC}
        gcloud --project $PROJECT compute instance-groups managed set-target-pools $instances_group_region --target-pools $POOL --region $REGION

        # Create Forwarding Rules
        echo -e ${GREEN}=== Create Forwarding Rules: ${YELLOW}$RULE ${NC}
        gcloud --project $PROJECT compute forwarding-rules create $RULE --region $REGION --target-pool https://www.googleapis.com/compute/v1/projects/$PROJECT/regions/$REGION/targetPools/$POOL --ip-protocol $PROTO --ports $PORT

        ip=$(lookup_lb_ip)
        
        [ ! -z "$ip" ] && dns_update $ip
    
        $igctrl dns
    fi
    
    set_account $default_account
}

###
stop() {
    set_account $lb_account
        
    $igctrl stop
    
    # Delete Forwarding Rules
    echo -e ${GREEN}=== Delete Forwarding Rules: ${YELLOW}$RULE ${NC}
    gcloud --project $PROJECT -q compute forwarding-rules delete $RULE --region $REGION

    # Delete Load Balancer
    echo -e ${GREEN}=== Delete Load Balancer: ${YELLOW}$POOL ${NC}
    gcloud --project $PROJECT -q compute target-pools delete $POOL --region $REGION
    
    set_account $default_account
    
    dns_remove
}

###
dns_update() {
    last_account=$(get_account)
    set_account $dns_account
    
    # DNS transaction start
    echo -e ${YELLOW}=== Starting DNS Changes: ${GREEN}$LB.creeper.tw ${NC}
    $dnsupdate start $dns_project creeper-tw
    
    echo -e ${GREEN}== Updating ${YELLOW}$LB.creeper.tw IN A $1 ${NC}
    $dnsupdate A creeper-tw $LB creeper.tw 1min 1min $1
    
    # echo -e ${GREEN}== Updating ${YELLOW}mc.creeper.tw IN CNAME $LB.creeper.tw ${NC}
    # $dnsupdate CNAME creeper-tw mc creeper.tw $LB.creeper.tw. 3hour 1min
    
    # DNS transaction commit
    echo -e ${YELLOW}=== Commiting DNS Changes: ${GREEN}$LB.creeper.tw ${NC}
    $dnsupdate commit $dns_project creeper-tw
    
    set_account $last_account
}

###
DBFILE=~/.db/dnsdb.txt
dns_remove() {
    
	declare -A dnsdb
    [ -f $DBFILE ] && source $DBFILE
	LAST=${dnsdb[$(basename $0)]}
	
    last_account=$(get_account)
    set_account $dns_account
    
    # DNS transaction start
    echo -e ${YELLOW}=== Starting DNS Changes: ${GREEN}$LB.creeper.tw ${NC}
    $dnsupdate start $dns_project creeper-tw
    
    echo -e ${GREEN}== Removing ${YELLOW}$LB.creeper.tw IN A ... ${NC}
    $dnsupdate del $dns_project creeper-tw $LB creeper.tw 1min 3hour A
    
    # [ ! -z "$LAST" ] && echo -e ${GREEN}== Updating ${YELLOW}mc.creeper.tw IN CNAME $LAST.creeper.tw ${NC}
    # [ ! -z "$LAST" ] && $dnsupdate CNAME creeper-tw mc creeper.tw $LAST.creeper.tw. 1min 3hour
    # [ -z "$LAST" ] && $dnsupdate CNAME creeper-tw mc creeper.tw $default_HOST.creeper.tw. 1min 3hour
    
    # DNS transaction commit
    echo -e ${YELLOW}=== Commiting DNS Changes: ${GREEN}$LB.creeper.tw ${NC}
    $dnsupdate commit $dns_project creeper-tw
    
    set_account $last_account
}

###
case "$1" in
  install)
	addto_crontab "# Load Balancer Start $(basename $0)"
    addto_crontab "35 19 * * 6 $runscreen $(readlink -e $0) start"
	# addto_crontab "#Load Balancer Stop $(basename $0)"
    # addto_crontab "0 21 * * 6 $runscreen $(readlink -e $0) stop"
    exit
    ;;
  remove)
    delfrom_crontab "$(basename $0)"
    exit
    ;;
  start)
    start
    exit
    ;;
  stop)
    stop
    exit
    ;;
  *)
    start
esac
