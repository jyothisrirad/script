#!/bin/bash

. /home/sita/script/include/common_helper

screen_name=admin

as_user "screen -dmS $screen_name $*"
