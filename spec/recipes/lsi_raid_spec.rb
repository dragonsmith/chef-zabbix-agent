require_relative '../spec_helper'

describe 'zabbix-agent::lsi_raid' do

  subject { ChefSpec::Runner.new { |node| node.set['base']['mail_to'] = 'zabbix@evilmartians.com'}.converge(described_recipe) }
  let(:config_file) { subject.file('/etc/zabbix/agent-conf.d/megasas.conf') }
  let(:zabbix_service) { subject.service('zabbix-agent') }

  it { expect(zabbix_service).to do_nothing }

  it { is_expected.to add_apt_repository('le-vert') }

  ['megacli', 'megaclisas-status'].each do |pkg|
    it { is_expected.to install_package pkg }
  end

  ['ruby1.9.1', 'ruby1.9.1-dev', 'libruby1.9.1'].each do |pkg|
    it { is_expected.to install_package pkg }
  end

  it { is_expected.to render_file('/etc/default/megaclisas-statusd')
                       .with_content('MAILTO="zabbix@evilmartians.com"')
  }

  it { is_expected.to create_cookbook_file('/tmp/megacli_status.gem')
                       .with(mode: '0644',source: 'megacli_status.gem')
  }

  it { is_expected.to install_gem_package 'megacli_status' }
  it { is_expected.to render_file('/etc/zabbix/agent-conf.d/megasas.conf')
                       .with_content('UserParameter=dev.megasas,/usr/bin/sudo /usr/local/bin/megacli_status -n Zabbix')
  }

  it { is_expected.to install_sudo('zabbix-megasas')
                       .with(user: 'zabbix', commands: ['/usr/local/bin/megacli_status -n Zabbix'], nopasswd: true)
  }

  it { expect(config_file).to notify('service[zabbix-agent]').to(:restart) }

end
