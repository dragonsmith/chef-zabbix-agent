if node[:pgbouncer]
  default[:zabbix][:pgpass_records] = [
    {
      listen_address: node[:pgbouncer][:listen_address],
      listen_port:    node[:pgbouncer][:listen_port],
      database:       'pgbouncer',
      username:       node[:pgbouncer][:admin_users].first,
      password:       node[:pgbouncer][:userlist][node[:pgbouncer][:admin_users].first]
    }
  ]
end
