#!/bin/bash

. /home/sita/script/include/console.color
. /home/sita/script/include/common_helper
. /home/sita/script/include/gcloud_helper

###
dnsupdate=/home/sita/script/mis/gcloud.dns.update.sh

###
ig_account=sita@changen.com.tw
dns_account=chsliu@gmail.com
default_account=$(get_account)
PROJECT=creeper-199909
REGION=asia-east1
instances_group=bc
instances_group_region=bc2
instances_count_min=2
instances_count_max=9
HOSTS=r53

###
start() {
    set_account $ig_account
    
    # Start Autoscaling
    echo -e ${GREEN}=== Start Autoscaling: ${YELLOW}$instances_group_region, min $instances_count_min, max $instances_count_max ${NC}
    gcloud --project creeper-199909 compute instance-groups managed set-autoscaling $instances_group_region --max-num-replicas=$instances_count_max --min-num-replicas=$instances_count_min --region asia-east1
    
    set_account $default_account
}

###
stop() {
    set_account $ig_account
    
    # Stop Autoscaling
    echo -e ${GREEN}=== Stop Autoscaling: ${YELLOW}$instances_group_region ${NC}
    gcloud --project $PROJECT compute instance-groups managed stop-autoscaling $instances_group_region --region $REGION
    
    group=$(gcloud --project $PROJECT compute instance-groups managed list-instances $instances_group_region --region $REGION | tail -n +2 | awk '{ printf ("%s,", $1) }')
    
    # Delete instances
    echo -e ${GREEN}=== Delete instances: ${YELLOW}${group%?} ${NC}
    gcloud --project $PROJECT compute instance-groups managed delete-instances $instances_group_region --instances=${group%?} --region $REGION
    
    dns_remove $(gcloud --project $PROJECT compute instances list | grep "${instances_group_region}-" | awk '{printf ("%s\n", $9)}' | sort -u | tr '\n' ' ')
    
    set_account $default_account
}

###
dns_update() {
    last_account=$(get_account)
    set_account $dns_account
    
    echo -e ${GREEN}=== Updating ${YELLOW}r53.creeper.tw IN A $* ${GREEN}1min ${NC}
    $dnsupdate start creeper-196707 creeper-tw
    $dnsupdate A creeper-tw $HOSTS creeper.tw 1min 1min $*
    $dnsupdate commit creeper-196707 creeper-tw
    
    set_account $last_account
}

dns_remove() {
    last_account=$(get_account)
    set_account $dns_account
    
    echo -e ${GREEN}=== Removing ${YELLOW}r53.creeper.tw IN A $* ${GREEN}1min ${NC}
    $dnsupdate start creeper-196707 creeper-tw
    $dnsupdate del creeper-196707 creeper-tw $HOSTS creeper.tw 1min 3hour A $*
    $dnsupdate commit creeper-196707 creeper-tw
    
    set_account $last_account
}

###
case "$1" in
  install)
	addto_crontab "#Instances Group DNS update $(basename $0)"
    addto_crontab "* 19-20 * * 6 /bin/bash $(readlink -e $0) dns"
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
    dns_update $(gcloud --project $PROJECT compute instances list | grep "${instances_group_region}-" | awk '{printf ("%s\n", $9)}' | sort -u | tr '\n' ' ')
    exit
    ;;
  *)
    start
esac
