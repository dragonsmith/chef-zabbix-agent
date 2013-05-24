# zabbix-agent

## Description
Installs and configures zabbix-agent and appropriate custom scripts for it if needed.

## Attributes

* `node['zabbix']['listen']` - Ip address or interface to listen on. Default: _0.0.0.0_
* `node['zabbix']['server_name']` - Server name or ip address that is allowed to connect to this zabbix\_agent. Default: _zabbix.example.com_
* `node['zabbix']['agent_debuglevel']` - Log level. Default: _3_
* `node['zabbix']['agent_log_dir']` - Directory to put log files in. Default: _/var/log/zabbix-agent_
* `node['zabbix']['agent_pid_dir']` - Directory to put pid file in. Default: _/var/run/zabbix_

## Additional user defined zabbix items

**iostat**

`dev.iostat[*]`

Where star stands for disk name. Show iops for that device.

**mdraid**

`dev.md[*]`

Invoked automatically if /proc/mdstat exists.
Creates script that checks the status of md raid device.

# Copyright
2013 Evil Martians (surrender@evilmartians.com)

