#
# Cookbook Name:: zabbix-agent
# Recipe:: redis
#
# Author:: Kirill Kouznetsov <agon.smith@gmail.com>
#
# Copyright 2015, Evil Martians
#

service 'zabbix-agent' do
  action :nothing
end

template "#{node['zabbix']['conf_dir']}/agent-conf.d/redis-custom-user-parameters.conf" do
  source 'redis-user-parameters.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[zabbix-agent]', :delayed
  variables(
    lazy do
      {
        redis_password: get_redis_password(node['zabbix']['redis_config']),
        redis_host: get_redis_host(node['zabbix']['redis_config']),
        redis_port: get_redis_port(node['zabbix']['redis_config'])
      }
    end
  )
end

cron 'write zabbix_key with unixtime to redis' do
  minute '*/1'
  command "/usr/bin/redis-cli -a #{get_redis_password(node['zabbix']['redis_config'])} -h #{get_redis_host(node['zabbix']['redis_config'])} -p #{get_redis_port(node['zabbix']['redis_config'])} set zabbix_key `date +\%s`"
end

# zabbix_agent_redis 'main'
