#
# Cookbook Name:: zabbix-agent
# Recipe:: iostat
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

package 'sysstat'
package 'gawk'

template '/etc/zabbix/agent-conf.d/userparameter_iostat.conf' do
  source 'userparameter_iostat.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, 'service[zabbix-agent]', :delayed
end

directory '/usr/local/bin'

%w(collect parse).each do |script|
  cookbook_file "/usr/local/bin/iostat-#{script}.sh" do
    source "iostat-#{script}.sh"
    mode '0755'
  end
end

# Create crontask via cron cookbook
cron_d 'zabbix_iostat_collect' do
  command '/usr/local/bin/iostat-collect.sh /tmp/iostat.out 8 > /dev/null'
  user    'zabbix'
  minute  '*'
  hour    '*'
  day     '*'
  month   '*'
  weekday '*'
end
