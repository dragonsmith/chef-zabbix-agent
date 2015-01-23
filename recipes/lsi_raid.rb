#
# Cookbook Name:: zabbix-agent
# Recipe:: megasas
#

apt_repository "le-vert" do
  uri "http://hwraid.le-vert.net/#{node['lsb']['id'].downcase}"
  distribution node['lsb']['codename']
  components ['main']
  key 'http://hwraid.le-vert.net/debian/hwraid.le-vert.net.gpg.key'
end

['megacli', 'megaclisas-status'].each { |pkg| package pkg }
['ruby1.9.1', 'ruby1.9.1-dev', 'libruby1.9.1'].each { |pkg| package pkg }

service node['zabbix']['service'] do
  pattern  'zabbix_agentd'
  supports [restart: true]
  action   :nothing
end

template '/etc/default/megaclisas-statusd' do
  owner 'root'
  mode '0644'
  source 'megaclisas-statusd.erb'
end

cookbook_file '/tmp/megacli_status.gem' do
  source "megacli_status.gem"
  mode '0644'
end

gem_package "megacli_status" do
  source "/tmp/megacli_status.gem"
  action :install
end

file '/etc/zabbix/agent-conf.d/megasas.conf' do
  content 'UserParameter=dev.megasas,/usr/bin/sudo /usr/local/bin/megacli_status perform -n Zabbix'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, "service[#{node['zabbix']['service']}]", :delayed
end

sudo 'zabbix-megasas' do
  user 'zabbix'
  commands ['/usr/local/bin/megacli_status perform -n Zabbix']
  nopasswd true
end
