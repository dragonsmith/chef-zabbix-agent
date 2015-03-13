# zabbix-agent cookbook CHANGELOG

## v1.3.8 (2015-03-13)

* iostat

## v1.3.7 (2015-03-13)

* runit services

## v1.3.6 (2015-03-02)

* configure official zabbix repo for all debian-based distros.

## v1.3.5 (2015-03-02)

* switching to zabbix-agent 2.4 by default.
* specfile for recipe[zabbix-agent::pg-monitoring] updated.

## v1.3.4 (2015-02-25)

* pg-monitoring now uses [pg_monz](https://github.com/pg-monz/pg_monz) suite

## v1.3.3 (2015-01-27)

* new recipe for md arrays check based on [linuxsquad/zabbix_mdraid](https://github.com/linuxsquad/zabbix_mdraid)

## v1.3.1 (2014-08-28)

* shell oneliner command was updated for `proc.rss.mem[*]`
* spec file updated

Zabbix prohibits special characters inside item parameters, so custom parameter formar was implemented. See [README](/dragonsmith/chef-zabbix-agent#proc-mem-rss) for details.

## v1.3.0 UNSTABLE (2014-08-27)

* ChefSpec full coverage
* cookbook dependencies: *apt* and *sudo*
* iostat Zabbix UserParameters are deprecated and were removed
* UserParameter `proc.mem.rss[*]` test configuration for per process RSS memory monitoring.
