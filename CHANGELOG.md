# zabbix-agent cookbook CHANGELOG

## v0.3.16 (2017-06-17)

* Making this cookbook compatible with Chef 13.

## v1.3.15 (2016-09-13)

* Hotfixes. Do not hurry.

## v1.3.14 (2016-09-13)

* User Parameter redis.zabbix.get was added.

## v1.3.13 (2016-05-12)

* not_if tiny syntax fix.

## v1.3.12 (2016-05-12)

* do not add custom apt repo on Ubuntu Xenial 16.04

## v1.3.9 (2015-03-14)

* iostat data monitoring

## v1.3.8 (2015-03-13)

* Many updates to PgMonz Zabbix templates disabling some items/triggers and changes to graphs.
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
