require 'spec_helper'

describe 'nexus::config', :type => :class do
  let(:params) {
    {
      'nexus_root'            => '/opt',
      'nexus_home_dir'        => 'nexus',
      'nexus_host'            => '1.1.1.1',
      'nexus_port'            => '8888',
      'nexus_context'         => '/nexus',
      'nexus_work_dir'        => '/opt/sonatype-work/nexus3',
      'version'               => '3.6.0',
      'nexus_data_folder'     => '',
      'nexus_work_dir_manage' => 'true',
    }
  }

  context 'with nexus version 2.x test values' do
    it { should contain_class('nexus::config') }

    it { should contain_file_line('nexus-application-host').with(
      'path'  => '/opt/sonatype-work/nexus3/etc/nexus.properties',
      'match' => '^application-host',
      'line'  => 'application-host=1.1.1.1',
    ) }

    it { should contain_file_line('nexus-application-port').with(
      'path'  => '/opt/sonatype-work/nexus3/etc/nexus.properties',
      'match' => '^application-port',
      'line'  => 'application-port=8888',
    ) }

    it { should contain_file_line('nexus-context-path').with(
      'path'  => '/opt/sonatype-work/nexus3/etc/nexus.properties',
      'match' => '^nexus-context-path',
      'line'  => 'nexus-context-path=/nexus',
    ) }

    it { should contain_file_line('nexus-work').with(
      'path'  => '/opt/sonatype-work/nexus3/etc/nexus.properties',
      'match' => '^nexus-work',
      'line'  => 'nexus-work=/opt/sonatype-work/nexus3',
    ) }
  end
end

# vim: sw=2 ts=2 sts=2 et :
