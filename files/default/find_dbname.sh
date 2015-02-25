#!/bin/bash

# Get list of Database Name which you want to monitor.
# The default settings are excepted template databases(template0/template1).
#
# :Example
#
# If you want to monitor "foo" and "bar" databases, you set the GETDB as
# GETDB="select datname from pg_database where datname in ('foo','bar');"

GETDB="select datname from pg_database where datistemplate = 'f';"

for dbname in $(psql -p $1 -U $2 -d $3 -A -t -c "${GETDB}"); do
    dblist="$dblist,"'{"{#DBNAME}":"'$dbname'"}'
done
echo '{"data":['${dblist#,}' ]}'
