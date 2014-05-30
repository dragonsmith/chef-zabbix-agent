#
# Cookbook Name:: zabbix-agent
# Recipe:: default
#

apt_repository "zabbix" do
  uri "http://repo.zabbix.com/zabbix/2.2/#{node['platform']}/"
  distribution node['lsb']['codename']
  components ["main"]
  key "http://repo.zabbix.com/zabbix-official-repo.key"
  not_if { platform?("ubuntu") and node['lsb']['release'].to_i >= 14 }
end

package node['zabbix']['package'] do
  action :install
end

listen_ip = if IPAddress.valid?(node['zabbix']['listen'])
  node['zabbix']['listen']
elsif %w{any all}.include?(node['zabbix']['listen'])
  "0.0.0.0"
else
  node['network']['interfaces'][node['zabbix']['listen']]['addresses'].select { |address, data| data['family'] == "inet" }.first.first
end

template node['zabbix']['agent_conf'] do
  source   "zabbix_agentd.conf.erb"
  owner    "root"
  group    "root"
  mode     "0644"
  notifies :restart, "service[#{node['zabbix']['service']}]", :delayed
  variables(
    :logfile => "#{node['zabbix']['agent_log_dir']}/zabbix_agentd.log",
    :pidfile => "#{node['zabbix']['agent_pid_dir']}/zabbix_agentd.pid",
    :debuglevel => node['zabbix']['agent_debuglevel'],
    :server_name => node['zabbix']['server_name'],
    :include_dir => "/etc/zabbix/agent-conf.d",
    :listen => listen_ip
  )
end

directory "/etc/zabbix/agent-conf.d" do
  owner "root"
  group "root"
  mode 0755
  recursive true
end

%w{log pid}.each do |i|
  directory node['zabbix']["agent_#{i}_dir"] do
    owner "zabbix"
    group "zabbix"
    mode 0755
    recursive true
  end
end

group "shadow" do
  action :modify
  members ['zabbix']
  append true
end

service node['zabbix']['service'] do
  pattern  "zabbix_agentd"
  supports [ :restart => true ]
  action   [ :enable, :start ]
end

file "/etc/zabbix/agent-conf.d/iostat.conf" do
  content %Q{UserParameter=dev.iostat[*],/usr/bin/sudo /usr/bin/iostat -x | /usr/bin/awk '/^$1 /{print $$$2}'}
  owner "root"
  group "root"
  mode 0644
  notifies :restart, "service[#{node['zabbix']['service']}]", :delayed
end

begin
  sudo "zabbix-iostat" do
    user "zabbix"
    commands ['/usr/bin/iostat -x']
    nopasswd true
  end
rescue NameError => e
  Chef::Log.info(e.message)
  Chef::Log.info("LWRP for sudo is not defined. Skipping resource sudo[zabbix-iostat] ...")
end

if ::File.exists?("/proc/mdstat")
  include_recipe "zabbix-agent::mdraid"
end

# vim: ts=2 sw=2 et ai
