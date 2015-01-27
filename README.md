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

### mdraid

`mdraid[*]`

`mdraid.discovery`

Use autodiscovering for find MD devices
Uses [external shell script](files/default/zabbix_mdraid.sh) to discover and check status of md raid devices.

### pg-monitoring

`psql.max_connections[*]`

`psql.current_connections[*]`

Accept PostgreSQL listen port number as you may have multiple PostgreSQL instances listening on different ports.

This is an extremely tiny configuration for PostgreSQL monitoring. Please use a full-scale one if you really want to user this RDBMS in production. I'll add something more useful here in the future.

### proc-mem-rss

`proc.mem.rss[*]`

Accepts search string that is converted to regular expression for *pgrep -of* command using this rule: All `spaces` are convertied to `.*`. This <strike>shi</strike>... behavior was implemented because of Zabbix restriction for item parameters: *special characters "\, ', ", `, *, ?, [, ], {, }, ~, $, !, &, ;, (, ), <, >, |, #, @, 0x0a" are not allowed in the parameters* .
Returns RSS value for the oldest process that matches your regex *multiplied by 1024* to get **bytes** instead of Kb.

# Sponsor

Sponsored by [Evil Martians](http://evilmartians.com)

# License and Author

Kirill Kouznetsov (agon.smith@gmail.com)

Copyright (C) 2012-2014 Kirill Kouznetsov

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
