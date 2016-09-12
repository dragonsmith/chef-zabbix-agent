require_relative '../spec_helper'

describe 'zabbix-agent::redis' do
  subject { ChefSpec::SoloRunner.new.converge(described_recipe) }

  let(:config_template) { subject.template('/etc/zabbix/zabbix_agentd.conf') }

  it 'Does nothing with service[zabbix-agent]' do
    is_expected.not_to start_service('zabbix-agent')
  end

  it 'Creates zabbix agent custom config file' do
    is_expected.to create_template('/etc/zabbix/agent-conf.d/redis-custom-user-parameters.conf')
  end

  it 'Creates cron task that writes unixtime to zabbix_key to redis' do
    is_expected.to create_cron('write zabbix_key with unixtime to redis')
  end
end
