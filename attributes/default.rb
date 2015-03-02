#
# Cookbook Name:: zabbix-agent
# Attribute:: default
#

case platform
when 'debian', 'ubuntu'
  set_unless['zabbix']['service'] = 'zabbix-agent'
  default['zabbix']['package'] = 'zabbix-agent'
  default['zabbix']['agent_conf'] = '/etc/zabbix/zabbix_agentd.conf'
end

default['zabbix']['version'] = '2.4'
default['zabbix']['listen'] = '0.0.0.0'
default['zabbix']['agent_log_dir'] = '/var/log/zabbix-agent'
default['zabbix']['agent_pid_dir'] = '/var/run/zabbix'

default['zabbix']['server_name'] = 'zabbix.example.com'
default['zabbix']['agent_debuglevel'] = '3'
