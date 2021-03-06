#
# Cookbook Name:: zabbix-agent
# Recipe:: pg-monitoring
#
# Author:: Kirill Kouznetsov (<agon.smith@gmail.com>)
#
# Copyright 2014, Kirill Kouznetsov
#

service node['zabbix']['service'] do
  pattern  'zabbix_agentd'
  supports [restart: true]
  action   :nothing
end

template '/etc/zabbix/agent-conf.d/userparameter_pg_monz.conf' do
  source 'userparameter_pg_monz.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, 'service[zabbix-agent]', :delayed
end

sudo 'zabbix_pg_monz'  do
  user 'zabbix'
  runas 'postgres'
  commands [
"/usr/bin/psql -p [0-9]* -U postgres -d postgres -A -t -c SELECT round(blks_hit*100/(blks_hit+blks_read)\\, 2) AS cache_hit_ratio FROM pg_stat_database WHERE datname \\= 'postgres' and blks_read > 0 union all select 0.00 AS cache_hit_ratio order by cache_hit_ratio desc limit 1",
"/usr/bin/psql -p [0-9]* -U postgres -d postgres -A -t -c SELECT round(blks_hit*100/(blks_hit+blks_read)\\, 2) AS cache_hit_ratio FROM pg_stat_database WHERE datname \\= '*' and blks_read > 0 union all select 0.00 AS cache_hit_ratio order by cache_hit_ratio desc limit 1",
'/usr/bin/psql -p [0-9]* -U postgres -d postgres -A -t -c select 1',
'/usr/bin/psql -p [0-9]* -U postgres -d postgres -A -t -c select buffers_alloc from pg_stat_bgwriter',
'/usr/bin/psql -p [0-9]* -U postgres -d postgres -A -t -c select buffers_backend from pg_stat_bgwriter',
'/usr/bin/psql -p [0-9]* -U postgres -d postgres -A -t -c select buffers_backend_fsync from pg_stat_bgwriter',
'/usr/bin/psql -p [0-9]* -U postgres -d postgres -A -t -c select buffers_checkpoint from pg_stat_bgwriter',
'/usr/bin/psql -p [0-9]* -U postgres -d postgres -A -t -c select buffers_clean from pg_stat_bgwriter',
'/usr/bin/psql -p [0-9]* -U postgres -d postgres -A -t -c select checkpoints_req from pg_stat_bgwriter',
'/usr/bin/psql -p [0-9]* -U postgres -d postgres -A -t -c select checkpoints_timed from pg_stat_bgwriter',
"/usr/bin/psql -p [0-9]* -U postgres -d postgres -A -t -c select count(*) from pg_stat_activity where state \\= 'active' and now() - query_start > '[0-9]* sec'\\:\\:interval and query ilike 'select%'",
"/usr/bin/psql -p [0-9]* -U postgres -d postgres -A -t -c select count(*) from pg_stat_activity where state \\= 'active' and now() - query_start > '[0-9]* sec'\\:\\:interval and query ~* '^(insert|update|delete)'",
"/usr/bin/psql -p [0-9]* -U postgres -d postgres -A -t -c select count(*) from pg_stat_activity where state \\= 'active' and now() - query_start > '[0-9]* sec'\\:\\:interval",
"/usr/bin/psql -p [0-9]* -U postgres -d postgres -A -t -c select count(*) from pg_stat_activity where waiting \\= 't'",
'/usr/bin/psql -p [0-9]* -U postgres -d postgres -A -t -c select count(*) from pg_stat_activity;',
"/usr/bin/psql -p [0-9]* -U postgres -d postgres -A -t -c select count(state) from pg_stat_activity where state \\= 'active'",
"/usr/bin/psql -p [0-9]* -U postgres -d postgres -A -t -c select count(state) from pg_stat_activity where state \\= 'idle in transaction'",
"/usr/bin/psql -p [0-9]* -U postgres -d postgres -A -t -c select count(state) from pg_stat_activity where state \\= 'idle'",
"/usr/bin/psql -p [0-9]* -U postgres -d postgres -A -t -c select deadlocks from pg_stat_database where datname \\= '*'",
'/usr/bin/psql -p [0-9]* -U postgres -d postgres -A -t -c select maxwritten_clean from pg_stat_bgwriter',
"/usr/bin/psql -p [0-9]* -U postgres -d postgres -A -t -c select numbackends from pg_stat_database where datname \\= '*'",
"/usr/bin/psql -p [0-9]* -U postgres -d postgres -A -t -c select pg_database_size('*') from pg_database where datname \\= '*'",
'/usr/bin/psql -p [0-9]* -U postgres -d postgres -A -t -c select sum(xact_commit) from pg_stat_database',
'/usr/bin/psql -p [0-9]* -U postgres -d postgres -A -t -c select sum(xact_rollback) from pg_stat_database',
"/usr/bin/psql -p [0-9]* -U postgres -d postgres -A -t -c select temp_bytes from pg_stat_database where datname \\= '*'",
"/usr/bin/psql -p [0-9]* -U postgres -d postgres -A -t -c select tup_deleted from pg_stat_database where datname \\= '*'",
"/usr/bin/psql -p [0-9]* -U postgres -d postgres -A -t -c select tup_fetched from pg_stat_database where datname \\= '*'",
"/usr/bin/psql -p [0-9]* -U postgres -d postgres -A -t -c select tup_inserted from pg_stat_database where datname \\= '*'",
"/usr/bin/psql -p [0-9]* -U postgres -d postgres -A -t -c select tup_returned from pg_stat_database where datname \\= '*'",
"/usr/bin/psql -p [0-9]* -U postgres -d postgres -A -t -c select tup_updated from pg_stat_database where datname \\= '*'",
"/usr/bin/psql -p [0-9]* -U postgres -d postgres -A -t -c select xact_commit from pg_stat_database where datname \\= '*'",
"/usr/bin/psql -p [0-9]* -U postgres -d postgres -A -t -c select xact_rollback from pg_stat_database where datname \\= '*'",
'/usr/bin/psql -p [0-9]* -U postgres -d postgres -A -t -c show max_connections',
"/usr/bin/psql -p [0-9]* -U postgres -d postgres -A -t -c select (select count(*) from pg_stat_activity)\\:\\:int*100/(select setting from pg_settings where name \\= 'max_connections')\\:\\:int",
'/usr/local/bin/find_dbname.sh [0-9]* postgres postgres',
'/usr/local/bin/find_dbname_table.sh [0-9]* postgres postgres'
  ]
  nopasswd true
end

directory '/usr/local/bin'

%w(find_dbname find_dbname_table).each do |script|
  cookbook_file "/usr/local/bin/#{script}.sh" do
    source "#{script}.sh"
    mode '0755'
  end
end
