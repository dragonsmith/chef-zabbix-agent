require_relative '../spec_helper'

describe 'zabbix-agent::pg-monitoring' do
  subject { ChefSpec::SoloRunner.new.converge(described_recipe) }
  let(:config_file) { subject.file('/etc/zabbix/agent-conf.d/postgresql.conf') }
  let(:zabbix_service) { subject.service('zabbix-agent') }

  it { expect(zabbix_service).to do_nothing }

  it do
    is_expected.to render_file('/etc/zabbix/agent-conf.d/postgresql.conf').with_content(/UserParameter=psql.max_connections\[\*\].+\nUserParameter=psql.current_connections\[\*\].+/m)
  end

  it { expect(config_file).to notify('service[zabbix-agent]').to(:restart).delayed }

  it do
    is_expected.to install_sudo('zabbix-postgresql').with(
      user: 'zabbix',
      runas: 'postgres',
      nopasswd: true
    )
  end

end
