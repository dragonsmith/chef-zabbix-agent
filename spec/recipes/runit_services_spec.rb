require_relative '../spec_helper'

describe 'zabbix-agent::runit_services' do
  subject { ChefSpec::SoloRunner.new.converge(described_recipe) }
  let(:user_param_template) { subject.template('/etc/zabbix/agent-conf.d/userparameter_runit_services.conf') }
  let(:zabbix_service) { subject.service('zabbix-agent') }

  it { expect(zabbix_service).to do_nothing }
  it { is_expected.to install_package 'bc' }

  it { is_expected.to render_file('/etc/zabbix/agent-conf.d/userparameter_runit_services.conf')
      .with_content(%r{runit_services.list.discovery, /usr/local/bin/find_runit_services.sh}) }

  it { expect(user_param_template).to notify('service[zabbix-agent]').to(:restart).delayed }

  it { is_expected.to install_sudo('zabbix_runit_services').with(
      user: 'zabbix',
      runas: 'root',
      nopasswd: true
    ) }

  it { is_expected.to create_directory('/usr/local/bin')}
  it { is_expected.to render_file('/usr/local/bin/find_runit_services.sh')}
  it { is_expected.to render_file('/usr/local/bin/value_for_runit_service.sh')}
end
