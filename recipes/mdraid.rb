#
# Cookbook Name:: zabbix-agent
# Recipe:: mdraid
#

service node['zabbix']['service'] do
  pattern  'zabbix_agentd'
  supports [restart: true]
  action   :nothing
end

cookbook_file '/usr/local/bin/zabbix_mdraid.sh' do
  owner 'zabbix'
  group 'zabbix'
  mode '0755'
  source 'zabbix_mdraid.sh'
end

cookbook_file '/etc/zabbix/agent-conf.d/userparameter_mdraid.conf' do
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, "service[#{node['zabbix']['service']}]", :delayed
end

sudo 'zabbix_mdadm' do
  user 'zabbix'
  commands [
    '/usr/local/bin/zabbix_mdraid.sh -D',
    '/usr/local/bin/zabbix_mdraid.sh -m/dev/md[0-9]* ?*'
  ]
  nopasswd true
end

# vim: ts=2 sw=2 et ai
