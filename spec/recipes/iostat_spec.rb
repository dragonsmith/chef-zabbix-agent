require_relative '../spec_helper'

describe 'zabbix-agent::iostat' do
  subject { ChefSpec::SoloRunner.new.converge(described_recipe) }
  let(:user_param_template) { subject.template('/etc/zabbix/agent-conf.d/userparameter_iostat.conf') }
  let(:zabbix_service) { subject.service('zabbix-agent') }

  it { expect(zabbix_service).to do_nothing }
  it { is_expected.to install_package 'sysstat' }
  it { is_expected.to install_package 'gawk' }

  it { is_expected.to render_file('/etc/zabbix/agent-conf.d/userparameter_iostat.conf')
      .with_content(%r{iostat.collect,echo 0}) }

  it { expect(user_param_template).to notify('service[zabbix-agent]').to(:restart).delayed }

  it { is_expected.to create_directory('/usr/local/bin')}
  it { is_expected.to render_file('/usr/local/bin/iostat-collect.sh')}
  it { is_expected.to render_file('/usr/local/bin/iostat-parse.sh')}
  it { is_expected.to create_cron_d('zabbix_iostat_collect') }
end
