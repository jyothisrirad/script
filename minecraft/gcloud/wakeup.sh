#!/bin/bash
#!/bin/bash -x

#=================================
bc1=/home/sita/script/minecraft/gcloud/bungeecord.sh

#=================================
wake_pve2() {
    echo === Wakeup pve2
    # wakeonlan '90:fb:a6:e4:52:80'
}

#=================================
wake_pve3() {
    echo === Wakeup pve3
    # wakeonlan '90:fb:a6:e4:52:80'
}

#=================================
wake_pve4() {
    echo === Wakeup pve4
    wakeonlan 'D0:50:99:38:8A:0F'
}

#=================================
wake_pve5() {
    echo === Wakeup pve5
    wakeonlan '40:8D:5C:4C:5C:54'
}

#=================================
wake_pve6() {
    echo === Wakeup pve6
    wakeonlan '00:FD:45:FC:17:7C'
}

#=================================
wake_pve7() {
    echo === Wakeup pve7
    wakeonlan '24:5E:BE:2A:B4:76'
}

#=================================
wake_g2() {
    echo === Wakeup g2
    # sudo ethtool enp3s0
    wakeonlan '90:fb:a6:e4:52:80'
    # sudo etherwake '90:fb:a6:e4:52:80'
}

#=================================
wake_w1() {
    echo === Wakeup w1
    #ip neigh add 192.168.1.250 lladdr 00:19:db:7d:c5:77  nud permanent dev br0
    #wol -i 192.168.1.250 00:19:db:7d:c5:77
    wakeonlan 'D0:50:99:38:88:A4'
}

#=================================
weekday_5pm() {
    echo == Weekday 5pm
    # wake_pve2
    # wake_pve3
    wake_pve4
    wake_pve5
    wake_pve6
    wake_g2
    [ $(date +%u) -eq '5' ] || $bc1 start micro
    [ $(date +%u) -eq '5' ] && $bc1 start small
}

weekday() {
    echo === Weekday
    [ $(date +%H) -eq '17' ] && weekday_5pm
}

#=================================
weekend_11am() {
    echo == Weekend 11am
    $bc1 start small
}

weekend() {
    echo === Weekend
    [ $(date +%H) -eq '11' ] && weekend_11am
}

#=================================
scheduler() { 
    [ $(date +%u) -lt '5' ] && weekday
    [ $(date +%u) -lt '5' ] || weekend
}

#=================================

case "$1" in
  cron)
    scheduler
    ;;
  pve2)
    wake_pve2
    ;;
  pve3)
    wake_pve3
    ;;
  pve4)
    wake_pve4
    ;;
  pve5)
    wake_pve5
    ;;
  pve6)
    wake_pve6
    ;;
  pve7)
    wake_pve7
    ;;
  g2)
    wake_g2
    ;;
  w1)
    wake_w1
    ;;
  *)
esac
