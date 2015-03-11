#!/bin/bash
#
# This file is managed by Chef.
# Do NOT modify this file directly.
#

services=(/etc/service/*)

for service in ${services[*]}; do
    list="$list,"'{"{#RUNIT_SERVICE}":"'$(basename $service)'"}'
done
echo '{"data":['${list#,}' ]}'
