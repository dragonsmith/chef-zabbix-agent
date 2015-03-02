require_relative '../spec_helper'

describe 'zabbix-agent::pg-monitoring' do
  subject { ChefSpec::SoloRunner.new.converge(described_recipe) }
  let(:user_param_template) { subject.template('/etc/zabbix/agent-conf.d/userparameter_pg_monz.conf') }
  let(:zabbix_service) { subject.service('zabbix-agent') }

  it { expect(zabbix_service).to do_nothing }

  it do
    is_expected.to render_file('/etc/zabbix/agent-conf.d/userparameter_pg_monz.conf')
      .with_content(%r{/usr/bin/sudo -u postgres /usr/bin/psql -p \$1 -U \$2 -d \$3 -A -t -c})
  end

  it { expect(user_param_template).to notify('service[zabbix-agent]').to(:restart).delayed }

  it do
    is_expected.to install_sudo('zabbix_pg_monz').with(
      user: 'zabbix',
      runas: 'postgres',
      nopasswd: true
    )
  end

  it { is_expected.to create_directory('/usr/local/bin')}
  it { is_expected.to render_file('/usr/local/bin/find_dbname.sh')}
  it { is_expected.to render_file('/usr/local/bin/find_dbname_table.sh')}
end
