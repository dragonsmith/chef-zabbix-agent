#
# Cookbook Name:: zabbix-agent
# Recipe:: pg-monitoring
#
# Author:: Kirill Kouznetsov (<agon.smith@gmail.com>)
#
# Copyright 2014, Kirill Kouznetsov
#

service node['zabbix']['service'] do
  pattern  'zabbix_agentd'
  supports [restart: true]
  action   :nothing
end

file '/etc/zabbix/agent-conf.d/postgresql.conf' do
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, 'service[zabbix-agent]', :delayed
  content <<-EOF
UserParameter=psql.max_connections[*],/usr/bin/sudo -u postgres /usr/bin/psql -qtp $1 -c 'show max_connections'
UserParameter=psql.current_connections[*],/usr/bin/sudo -u postgres /usr/bin/psql -qtp $1 -c 'SELECT SUM(numbackends) FROM pg_stat_database'
EOF
end

sudo 'zabbix-postgresql'  do
  user 'zabbix'
  runas 'postgres'
  commands [
    '/usr/bin/psql -qtp [0-9]* -c show\ max_connections',
    '/usr/bin/psql -qtp [0-9]* -c SELECT\ SUM(numbackends)\ FROM\ pg_stat_database'
  ]
  nopasswd true
end
