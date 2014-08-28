# zabbix-agent cookbook CHANGELOG

## v1.3.1 (2014-08-28)

* shell oneliner command was updated for `proc.rss.mem[*]`
* spec file updated

Zabbix prohibits special characters inside item parameters, so custom parameter formar was implemented. See [README](/dragonsmith/chef-zabbix-agent#proc-mem-rss) for details.

## v1.3.0 UNSTABLE (2014-08-27)

* ChefSpec full coverage
* cookbook dependencies: *apt* and *sudo*
* iostat Zabbix UserParameters are deprecated and were removed
* UserParameter `proc.mem.rss[*]` test configuration for per process RSS memory monitoring.