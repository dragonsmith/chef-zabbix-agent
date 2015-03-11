#
# Cookbook Name:: zabbix-agent
# Recipe:: runit_services
#
# Author:: Maxim Filatov (bregor@evilmartians.com)
#
# Copyright 2015, Evil Martians
#

service node['zabbix']['service'] do
  pattern  'zabbix_agentd'
  supports [restart: true]
  action   :nothing
end

package 'bc'

template '/etc/zabbix/agent-conf.d/userparameter_runit_services.conf' do
  source 'userparameter_runit_services.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, 'service[zabbix-agent]', :delayed
end

sudo 'zabbix_runit_services'  do
  user 'zabbix'
  runas 'root'
  commands [
    '/usr/local/bin/value_for_runit_service.sh [a-z]* pcpu',
    '/usr/local/bin/value_for_runit_service.sh [a-z]* vsz',
    '/usr/local/bin/value_for_runit_service.sh [a-z]* rsz'
  ]
  nopasswd true
end

directory '/usr/local/bin'

%w(find_runit_services value_for_runit_service).each do |script|
  cookbook_file "/usr/local/bin/#{script}.sh" do
    source "#{script}.sh"
    mode '0755'
  end
end
