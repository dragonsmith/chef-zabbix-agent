require_relative '../spec_helper'

describe 'zabbix-agent::default' do
  subject { ChefSpec::Runner.new.converge(described_recipe) }

  let(:config_template) { subject.template('/etc/zabbix/zabbix_agentd.conf') }

  context 'Old Ubuntu versions:' do
    subject { ChefSpec::Runner.new(version: '12.04').converge(described_recipe) }

    it do
      is_expected.to add_apt_repository('zabbix').with(
        uri: 'http://repo.zabbix.com/zabbix/2.2/ubuntu/',
        distribution: 'precise',
        key: 'http://repo.zabbix.com/zabbix-official-repo.key'
      )
    end
  end

  it { is_expected.to install_package('zabbix-agent') }

  it do
    is_expected.to modify_group('shadow').with(
      members: ['zabbix'],
      append: true
    )
  end

  it 'should create Zabbix Agent config file' do
    is_expected.to render_file('/etc/zabbix/zabbix_agentd.conf').with_content(
      /Server=zabbix.example.com\nServerActive=zabbix.example.com\n#\nHostname=.+$/m
    )
  end

  it { expect(config_template).to notify('service[zabbix-agent]').to(:restart).delayed }

  it do
    is_expected.to create_directory('/etc/zabbix/agent-conf.d').with(
      owner: 'root',
      group: 'root',
      mode: 0755,
      recursive: true
    )
  end

  %w(
    /var/log/zabbix-agent
    /var/run/zabbix
  ).each do |i|
    it do
      is_expected.to create_directory(i).with(
        owner: 'zabbix',
        group: 'zabbix',
        mode: 0755,
        recursive: true
      )
    end
  end

  it { is_expected.to enable_service('zabbix-agent').with(pattern: 'zabbix_agentd') }
  it { is_expected.to start_service('zabbix-agent') }

  it { is_expected.to include_recipe('zabbix-agent::proc-mem-rss')
  }

  context 'MD RAID is absent' do
    it { is_expected.to_not include_recipe('zabbix-agent::mdraid') }
  end

  context 'MD RAID is active' do
    before do
      allow(::File).to receive(:exist?).and_call_original
      allow(::File).to receive(:exist?).with('/proc/mdstat').and_return(true)
    end

    it { is_expected.to include_recipe('zabbix-agent::mdraid') }
  end
end
