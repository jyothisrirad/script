#!/bin/bash

dnsupdate=/home/sita/script/mis/dns.gandi.yozliu.pw.sh
##########################################################################
RECORD=test

echo === Testing: set
$dnsupdate set $RECORD 1.1.1.1 2.2.2.2
echo 
echo Result Should be: 1.1.1.1 2.2.2.2
$dnsupdate query $RECORD

echo === Testing: append
$dnsupdate append $RECORD 3.3.3.3
echo 
echo Result Should be: 1.1.1.1 2.2.2.2 3.3.3.3
$dnsupdate query $RECORD

echo === Testing: append repeated
$dnsupdate append $RECORD 3.3.3.3
echo 
echo Result Should be: 1.1.1.1 2.2.2.2 3.3.3.3
$dnsupdate query $RECORD

echo === Testing: remove
$dnsupdate remove $RECORD 2.2.2.2
echo 
echo Result Should be: 1.1.1.1 3.3.3.3
$dnsupdate query $RECORD

echo === Testing: del
$dnsupdate del $RECORD 
echo Result Should be: null
$dnsupdate query $RECORD
