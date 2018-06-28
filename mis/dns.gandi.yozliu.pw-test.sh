#!/bin/bash

dnsupdate=/home/sita/script/mis/dns.gandi.yozliu.pw.sh
##########################################################################
RECORD=test

echo === Testing: set
echo Result Should be: 1.1.1.1 2.2.2.2
$dnsupdate set $RECORD 1.1.1.1 2.2.2.2
echo
$dnsupdate query $RECORD

echo === Testing: set repeated
echo Result Should be: no action, 1.1.1.1 2.2.2.2
$dnsupdate set $RECORD 1.1.1.1 2.2.2.2
$dnsupdate query $RECORD

echo === Testing: append
echo Result Should be: 1.1.1.1 2.2.2.2 3.3.3.3
$dnsupdate append $RECORD 3.3.3.3
echo
$dnsupdate query $RECORD

echo === Testing: append repeated
echo Result Should be: no action, 1.1.1.1 2.2.2.2 3.3.3.3
$dnsupdate append $RECORD 3.3.3.3
$dnsupdate query $RECORD

echo === Testing: remove
echo Result Should be: 1.1.1.1 3.3.3.3
$dnsupdate remove $RECORD 2.2.2.2
echo
$dnsupdate query $RECORD

echo === Testing: del
echo Result Should be: null
$dnsupdate del $RECORD 
$dnsupdate query $RECORD
