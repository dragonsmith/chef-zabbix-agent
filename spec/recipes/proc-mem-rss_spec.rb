require_relative '../spec_helper'

describe 'zabbix-agent::proc-mem-rss' do
  subject { ChefSpec::Runner.new.converge(described_recipe) }
  let(:config_file) { subject.file('/etc/zabbix/agent-conf.d/proc-mem-rss.conf') }
  let(:zabbix_service) { subject.service('zabbix-agent') }

  it { expect(zabbix_service).to do_nothing }

  it do
    is_expected.to render_file('/etc/zabbix/agent-conf.d/proc-mem-rss.conf').with_content('UserParameter=proc.mem.rss[*],/bin/ps -o rss --no-heading $(/usr/bin/pgrep -of "$1")')
  end

  it { expect(config_file).to notify('service[zabbix-agent]').to(:restart).delayed }

end
