#
# Cookbook Name:: zabbix-agent
# Recipe:: mdraid
#

service node['zabbix']['service'] do
  pattern  'zabbix_agentd'
  supports [restart: true]
  action   :nothing
end

directory '/opt/chef/zabbix/' do
  owner 'root'
  group 'root'
  mode 0755
  recursive true
end

cookbook_file '/opt/chef/zabbix/check_md_raid' do
  owner 'zabbix'
  group 'zabbix'
  mode 0755
  source 'check_md_raid'
end

file '/etc/zabbix/agent-conf.d/md.conf' do
  content 'UserParameter=dev.md[*],/usr/bin/sudo /opt/chef/zabbix/check_md_raid -d /dev/md$1'
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, "service[#{node['zabbix']['service']}]", :delayed
end

sudo 'zabbix-mdadm' do
  user 'zabbix'
  commands ['/opt/chef/zabbix/check_md_raid -d /dev/md[0-9]']
  nopasswd true
end

# vim: ts=2 sw=2 et ai
