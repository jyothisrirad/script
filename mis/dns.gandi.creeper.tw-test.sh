#!/bin/bash

gandi=/home/sita/script/mis/dns.gandi.creeper.tw.sh
##########################################################################
RECORD=test

echo === Testing: set
echo Result Should be: 1.1.1.1 2.2.2.2
$gandi set $RECORD 1.1.1.1 2.2.2.2
echo
$gandi query $RECORD

echo === Testing: set repeated
echo Result Should be: no action, 1.1.1.1 2.2.2.2
$gandi set $RECORD 1.1.1.1 2.2.2.2
$gandi query $RECORD

echo === Testing: append
echo Result Should be: 1.1.1.1 2.2.2.2 3.3.3.3
$gandi append $RECORD 3.3.3.3
echo
$gandi query $RECORD

echo === Testing: append repeated
echo Result Should be: no action, 1.1.1.1 2.2.2.2 3.3.3.3
$gandi append $RECORD 3.3.3.3
$gandi query $RECORD

echo === Testing: remove
echo Result Should be: 1.1.1.1 3.3.3.3
$gandi remove $RECORD 2.2.2.2
echo
$gandi query $RECORD

echo === Testing: del
echo Result Should be: null
$gandi del $RECORD 
$gandi query $RECORD
