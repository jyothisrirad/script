#!/bin/bash

. /home/sita/script/include/common_helper
. /home/sita/script/include/console.color
. /home/sita/script/include/gcloud_helper

###
dnsupdate=/home/sita/script/mis/gcloud.dns.update.sh

###
default_account=$(get_account)

# dns_account=chsliu@gmail.com
# dns_project=creeper-196707
dns_account=sita@changen.com.tw
dns_project=creeper-199909

[ -z "$ig_account" ] && ig_account=sita@changen.com.tw
[ -z "$ig_project" ] && ig_project=creeper-199909
[ -z "$ig_region" ] && ig_region=asia-east1
[ -z "$instances_group" ] && instances_group=bc
[ -z "$instances_group_region" ] && instances_group_region=bc2
[ -z "$instances_count_min" ] && instances_count_min=1
[ -z "$instances_count_max" ] && instances_count_max=4
[ -z "$HOSTS" ] && HOSTS=r53

###
start() {
    set_account $ig_account
    
    # Start Autoscaling
    echo -e ${GREEN}=== Start Autoscaling: ${YELLOW}$instances_group_region, min $instances_count_min, max $instances_count_max ${NC}
    gcloud --project $ig_project compute instance-groups managed set-autoscaling $instances_group_region --max-num-replicas=$instances_count_max --min-num-replicas=$instances_count_min --region $ig_region
    
	# Health Check
	# gcloud --project $ig_project compute health-checks create tcp tcp-25565 --port=25565 --unhealthy-threshold=6
	
    set_account $default_account
}

###
stop() {
    set_account $ig_account
    
    # Stop Autoscaling
    echo -e ${GREEN}=== Stop Autoscaling: ${YELLOW}$instances_group_region ${NC}
    gcloud --project $ig_project compute instance-groups managed stop-autoscaling $instances_group_region --region $ig_region
    
    group=$(gcloud --project $ig_project compute instance-groups managed list-instances $instances_group_region --region $ig_region | tail -n +2 | awk '{ printf ("%s,", $1) }')
    
    # Delete instances
    echo -e ${GREEN}=== Delete instances: ${YELLOW}${group%?} ${NC}
    gcloud --project $ig_project compute instance-groups managed delete-instances $instances_group_region --instances=${group%?} --region $ig_region
    
    dns_remove $(gcloud --project $ig_project compute instances list | grep "${instances_group_region}-" | awk '{printf ("%s\n", $9)}' | sort -u | tr '\n' ' ')
    
    set_account $default_account
}

###
dns_update() {
    last_account=$(get_account)
    set_account $dns_account
    
    # DNS transaction start
    echo -e ${YELLOW}=== Starting DNS Changes: ${GREEN}$HOSTS.creeper.tw ${NC}
    $dnsupdate start $dns_project creeper-tw
    
    echo -e ${GREEN}== Updating ${YELLOW}$HOSTS.creeper.tw IN A $* ${GREEN}1min ${NC}
    $dnsupdate A creeper-tw $HOSTS creeper.tw 1min 1min $*
    
    # DNS transaction commit
    echo -e ${YELLOW}=== Commiting DNS Changes: ${GREEN}$HOSTS.creeper.tw ${NC}
    $dnsupdate commit $dns_project creeper-tw
    
    set_account $last_account
}

dns_remove() {
    last_account=$(get_account)
    set_account $dns_account
    
    # DNS transaction start
    echo -e ${YELLOW}=== Starting DNS Changes: ${GREEN}$HOSTS.creeper.tw ${NC}
    $dnsupdate start $dns_project creeper-tw
    
    echo -e ${GREEN}== Removing ${YELLOW}$HOSTS.creeper.tw IN A $* ${GREEN}1min ${NC}
    $dnsupdate del $dns_project creeper-tw $HOSTS creeper.tw 1min 3hour A $*
    
    # DNS transaction commit
    echo -e ${YELLOW}=== Commiting DNS Changes: ${GREEN}$HOSTS.creeper.tw ${NC}
    $dnsupdate commit $dns_project creeper-tw
    
    set_account $last_account
}

###
case "$1" in
  install)
	addto_crontab "# Instances Group DNS update $(basename $0)"
    addto_crontab "* 19-21 * * 6 $runscreen $(readlink -e $0) dns"
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
  dns)
    set_account $ig_account
    dns_update $(gcloud --project $ig_project compute instances list | grep "${instances_group_region}-" | awk '{printf ("%s\n", $9)}' | sort -u | tr '\n' ' ')
    exit
    ;;
  *)
    start
esac
