require_relative '../spec_helper'

describe 'zabbix-agent::pgbouncer' do
  subject do
    ChefSpec::SoloRunner.new do |node|
      node.set[:pgbouncer][:listen_address]               = '192.168.0.1'
      node.set[:pgbouncer][:listen_port]                  = '5432'
      node.set[:pgbouncer][:admin_users]                  = ['pgbouncer']
      node.set[:pgbouncer][:userlist]                     = {'pgbouncer' => 'supadupapass'}
      node.set[:postgresql][:defaults][:server][:version] = '9.4'
      node.set['zabbix']['service']                       = 'zabbix-agent'
    end.converge(described_recipe)
  end

  let(:user_param_template) { subject.cookbook_file('/etc/zabbix/agent-conf.d/userparameter_pgbouncer.conf') }
  let(:zabbix_service) { subject.service('zabbix-agent') }

  it { expect(zabbix_service).to do_nothing }

  it { is_expected.to render_file('/etc/zabbix/agent-conf.d/userparameter_pgbouncer.conf')
                       .with_content(%r{/usr/local/bin/pgbouncer.pool.discovery.sh}) }

  it { expect(user_param_template).to notify('service[zabbix-agent]').to(:restart).delayed }

  it { is_expected.to create_directory('/usr/local/bin')}

  it { is_expected.to render_file('/usr/local/bin/pgbouncer.stat.sh')
                       .with_content(%r{-qAtX -F: -h 192.168.0.1 -p 5432 -U pgbouncer pgbouncer})}

  it { is_expected.to render_file('/usr/local/bin/pgbouncer.pool.discovery.sh')
                       .with_content(%r{psql -h 192.168.0.1 -p 5432 -U pgbouncer -ltAF: --dbname=pgbouncer})}

  it { is_expected.to render_file('/var/lib/zabbix/.pgpass')
                       .with_content(%r{192.168.0.1:5432:pgbouncer:pgbouncer:supadupapass})}

end
