#
# Cookbook Name:: zabbix-agent
# Recipe:: pgbouncer
#

service node['zabbix']['service'] do
  pattern  'zabbix_agentd'
  supports [restart: true]
  action   :nothing
end

cookbook_file '/etc/zabbix/agent-conf.d/userparameter_pgbouncer.conf' do
  source 'userparameter_pgbouncer.conf'
  notifies :restart, "service[#{node['zabbix']['service']}]"
end

template '/var/lib/zabbix/.pgpass' do
  source 'pgpass.erb'
  mode   '0600'
  owner  'zabbix'
  group  'zabbix'
  notifies :restart, "service[#{node['zabbix']['service']}]"
end

directory '/usr/local/bin'

template '/usr/local/bin/pgbouncer.pool.discovery.sh' do
  source 'pgbouncer.pool.discovery.sh.erb'
  mode   '0755'
  owner  'zabbix'
  group  'zabbix'
  notifies :restart, "service[#{node['zabbix']['service']}]"
end

template '/usr/local/bin/pgbouncer.stat.sh' do
  source 'pgbouncer.stat.sh.erb'
  mode   '0755'
  owner  'zabbix'
  group  'zabbix'
  notifies :restart, "service[#{node['zabbix']['service']}]"
end
