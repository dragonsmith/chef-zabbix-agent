#
# Cookbook Name:: zabbix-agent
# Recipe:: default
#

apt_repository 'zabbix' do
  uri "http://repo.zabbix.com/zabbix/#{node['zabbix']['version']}/#{node['platform']}/"
  distribution node['lsb']['codename']
  components ['main']
  key 'http://repo.zabbix.com/zabbix-official-repo.key'
  not_if { platform?('ubuntu') && node['lsb']['release'].to_i >= 14 }
end

package node['zabbix']['package'] do
  action :install
end

listen_ip = if IPAddress.valid?(node['zabbix']['listen'])
              node['zabbix']['listen']
            elsif %w(any all).include?(node['zabbix']['listen'])
              '0.0.0.0'
            else
              node['network']['interfaces'][node['zabbix']['listen']]['addresses'].select { |address, data| data['family'] == 'inet' }.first.first
            end

template node['zabbix']['agent_conf'] do
  source   'zabbix_agentd.conf.erb'
  owner    'root'
  group    'root'
  mode     0644
  notifies :restart, "service[#{node['zabbix']['service']}]", :delayed
  variables(
    logfile: "#{node['zabbix']['agent_log_dir']}/zabbix_agentd.log",
    pidfile: "#{node['zabbix']['agent_pid_dir']}/zabbix_agentd.pid",
    debuglevel: node['zabbix']['agent_debuglevel'],
    server_name: node['zabbix']['server_name'],
    include_dir: '/etc/zabbix/agent-conf.d',
    listen: listen_ip
  )
end

directory '/etc/zabbix/agent-conf.d' do
  owner 'root'
  group 'root'
  mode 0755
  recursive true
end

%w(log pid).each do |i|
  directory node['zabbix']["agent_#{i}_dir"] do
    owner 'zabbix'
    group 'zabbix'
    mode 0755
    recursive true
  end
end

group 'shadow' do
  action :modify
  members ['zabbix']
  append true
end

service node['zabbix']['service'] do
  pattern  'zabbix_agentd'
  supports [restart: true]
  action   [:enable, :start]
end

include_recipe 'zabbix-agent::proc-mem-rss'

include_recipe 'zabbix-agent::mdraid' if ::File.exist?('/proc/mdstat')

# vim: ts=2 sw=2 et ai
