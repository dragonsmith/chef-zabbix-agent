require 'serverspec'

# Required by serverspec
set :backend, :exec

describe 'Zabbix Agent Custom Redis UserParameters' do
  describe file('/etc/zabbix/agent-conf.d/redis-custom-user-parameters.conf') do
    it { should be_file }
    it { should be_readable }
    it { should be_owned_by 'root' }
    its(:content) { should match(/^UserParameter=redis.mem.used/) }
    its(:content) { should match(/^UserParameter=redis.mem.max/) }
    its(:content) { should match(/^UserParameter=redis.ops.per.second/) }
    its(:content) { should match(/^UserParameter=redis.keys.total/) }
    its(:content) { should match(/^UserParameter=redis.keyspace.misses/) }
    its(:content) { should match(/^UserParameter=redis.connections.current/) }
    its(:content) { should match(/^UserParameter=redis.connections.max/) }
    its(:content) { should match(/^UserParameter=redis.blocked.clients/) }
    its(:content) { should match(/^UserParameter=redis.rejected.connections/) }
    its(:content) { should match(/-a neko_nya_nya -h 127.0.0.1 -p 6379/) }
  end

  describe command('/usr/bin/zabbix_get -s 127.0.0.1 -k redis.mem.used') do
    its(:stdout) { should match(/^[0-9]+$/) }
    its(:exit_status) { should eq 0 }
  end

  describe command('/usr/bin/zabbix_get -s 127.0.0.1 -k redis.mem.max') do
    its(:stdout) { should match(/^0$/) }
    its(:exit_status) { should eq 0 }
  end

  describe command('/usr/bin/zabbix_get -s 127.0.0.1 -k redis.ops.per.second') do
    its(:stdout) { should match(/^0$/) }
    its(:exit_status) { should eq 0 }
  end

  describe command('/usr/bin/zabbix_get -s 127.0.0.1 -k redis.keys.total') do
    its(:stdout) { should match(/^0$/) }
    its(:exit_status) { should eq 0 }
  end

  describe command('/usr/bin/zabbix_get -s 127.0.0.1 -k redis.keyspace.misses') do
    its(:stdout) { should match(/^0$/) }
    its(:exit_status) { should eq 0 }
  end

  describe command('/usr/bin/zabbix_get -s 127.0.0.1 -k redis.connections.current') do
    its(:stdout) { should match(/^1$/) }
    its(:exit_status) { should eq 0 }
  end

  describe command('/usr/bin/zabbix_get -s 127.0.0.1 -k redis.connections.max') do
    its(:stdout) { should match(/^128$/) }
    its(:exit_status) { should eq 0 }
  end

  describe command('/usr/bin/zabbix_get -s 127.0.0.1 -k redis.blocked.clients') do
    its(:stdout) { should match(/^0$/) }
    its(:exit_status) { should eq 0 }
  end

  describe command('/usr/bin/zabbix_get -s 127.0.0.1 -k redis.rejected.connections') do
    its(:stdout) { should match(/^0$/) }
    its(:exit_status) { should eq 0 }
  end
end
