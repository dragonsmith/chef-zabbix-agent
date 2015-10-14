require 'serverspec'

# Required by serverspec
set :backend, :exec

describe 'Zabbix Agent configuration' do
  describe file('/etc/zabbix/zabbix_agentd.conf') do
    it { should be_file }
    it { should be_readable }
    it { should be_owned_by 'root' }
    its(:content) { should match(/^Server=127.0.0.1$/) }
    its(:content) { should match(/^ServerActive=127.0.0.1$/) }
    its(:content) { should match(/^StartAgents=3$/) }
    its(:content) { should match(/^RefreshActiveChecks=60$/) }
    its(:content) { should match(/^DebugLevel=3$/) }
    its(:content) { should match(%r{^PidFile=/var/run/zabbix/zabbix_agentd.pid$}) }
    its(:content) { should match(%r{^LogFile=/var/log/zabbix-agent/zabbix_agentd.log$}) }
    its(:content) { should match(/^LogFileSize=10$/) }
    its(:content) { should match(/^Timeout=3$/) }
    its(:content) { should match(/^ListenIP=0.0.0.0$/) }
    its(:content) { should match(%r{^Include=/etc/zabbix/agent-conf.d$}) }
  end

  describe file('/etc/zabbix/agent-conf.d') do
    it { should be_directory }
  end

  describe service('zabbix-agent') do
    it { should be_enabled }
  end

  describe process('zabbix_agentd') do
    it { should be_running }
  end

  describe port(10_050) do
    it { should be_listening }
  end
end
