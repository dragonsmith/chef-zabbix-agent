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

template '/etc/zabbix/agent-conf.d/userparameter_pg_monz.conf' do
  source 'userparameter_pg_monz.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, 'service[zabbix-agent]', :delayed
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
