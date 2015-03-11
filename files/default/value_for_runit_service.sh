#!/bin/bash
#
# This file is managed by Chef.
# Do NOT modify this file directly.
#

service=/etc/service/$1
query=$2

if [ "$query" == "" ]
then
    echo "Usage: $0 <service> <query>"
    exit 1
fi

if grep -q 'CUR_PID_FILE=' $service/run # unicorn check
then
    APP_PATH=$(grep -e '^APP_PATH=' $service/run|awk -F'=' '{print $2}')
    PID_FILE=$(grep -e '^CUR_PID_FILE=' $service/run|awk -F'=' '{print $2}'|sed "s#\$APP_PATH#${APP_PATH}#")
    PID=$(cat $PID_FILE)
else
    PID=$(cat $service/supervise/pid)
fi

ps h -p $(/usr/bin/pgrep -g `ps h -p $PID -o pgrp` -d,) -o $query|paste -sd+|bc
