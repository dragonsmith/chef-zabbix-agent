require_relative '../spec_helper'

describe 'zabbix-agent::mdraid' do
  subject { ChefSpec::Runner.new.converge(described_recipe) }
  let(:config_file) { subject.file('/etc/zabbix/agent-conf.d/md.conf') }
  let(:zabbix_service) { subject.service('zabbix-agent') }

  it { expect(zabbix_service).to do_nothing }

  it do
    is_expected.to create_directory('/opt/chef/zabbix/').with(
      owner: 'root',
      mode: 'root',
      mode: 0755,
      recursive: true
    )
  end

  it do
    is_expected.to create_cookbook_file('/opt/chef/zabbix/check_md_raid').with(
      owner: 'zabbix',
      group: 'zabbix',
      mode: 0755,
      source: 'check_md_raid'
    )
  end

  it do
    is_expected.to render_file('/etc/zabbix/agent-conf.d/md.conf').with_content('UserParameter=dev.md[*],/usr/bin/sudo /opt/chef/zabbix/check_md_raid -d /dev/md$1')
  end

  it { expect(config_file).to notify('service[zabbix-agent]').to(:restart).delayed }

  it do
    is_expected.to install_sudo('zabbix-mdadm').with(
      user: 'zabbix',
      commands: ['/opt/chef/zabbix/check_md_raid -d /dev/md[0-9]'],
      nopasswd: true
    )
  end

end
