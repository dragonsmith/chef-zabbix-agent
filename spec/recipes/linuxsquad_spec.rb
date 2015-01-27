require_relative '../spec_helper'

describe 'zabbix-agent::linuxsquad' do

  subject { ChefSpec::SoloRunner.new { |node| node.set['base']['mail_to'] = 'zabbix@evilmartians.com'}.converge(described_recipe) }

  it { is_expected.to_not start_service('zabbix-agent') }

  it { is_expected.to render_file('/usr/local/bin/zabbix_mdraid.sh')
                       .with_content('AUTHOR: <The Best Zabbix admin>')}
  it { is_expected.to render_file('/etc/zabbix/agent-conf.d/userparameter_mdraid.conf')
                       .with_content('UserParameter=mdraid.discovery, sudo /usr/local/bin/zabbix_mdraid.sh -D')
  }

  it { is_expected.to install_sudo('zabbix_mdadm')
                       .with(user: 'zabbix',
                             commands: ['/usr/local/bin/zabbix_mdraid.sh -D',
                                        "/usr/local/bin/zabbix_mdraid.sh -m'[0-9]+' -$2'$3'"],
                             nopasswd: true)
  }

  it { expect(subject.cookbook_file('/etc/zabbix/agent-conf.d/userparameter_mdraid.conf')).to notify('service[zabbix-agent]').to(:restart) }
end
