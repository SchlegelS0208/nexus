require 'spec_helper'

describe 'nexus::package', :type => :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      let(:params) {
        {
          'deploy_pro'                    => false,
          'version'                       => '3.6.0',
          'revision'                      => '02',
          'download_site'                 => 'https://sonatype-download.global.ssl.fastly.net/nexus/3',
          'nexus_type'                    => 'unix',
          'nexus_root'                    => '/opt',
          'download_folder'               => '/opt',
          'nexus_home_dir'                => 'nexus',
          'nexus_user'                    => 'nexus',
          'nexus_group'                   => 'nexus',
          'nexus_work_dir'                => '/opt/sonatype-work/nexus3',
          'nexus_work_dir_manage'         => true,
          'nexus_work_recurse'            => true,
          'nexus_selinux_ignore_defaults' => true,
          'md5sum'                        => '',
        }
      }

      context 'with default values' do
        it { should contain_class('nexus::package') }

        it { should contain_wget__fetch('nexus-3.6.0-02-unix.tar.gz').with(
          'source'      => 'https://sonatype-download.global.ssl.fastly.net/nexus/3/nexus-3.6.0-02-unix.tar.gz',
          'destination' => '/opt/nexus-3.6.0-02-unix.tar.gz',
          'before'      => 'Exec[nexus-untar]',
          'source_hash' => '',
        ) }

        it { should contain_exec('nexus-untar').with(
          'command' => 'tar zxf /opt/nexus-3.6.0-02-unix.tar.gz --directory /opt',
          'creates' => '/opt/nexus-3.6.0-02',
          'path'    => [ '/bin', '/usr/bin' ],
        ) }

        it { should contain_file('/opt/nexus-3.6.0-02').with(
          'ensure'  => 'directory',
          'owner'   => 'nexus',
          'group'   => 'nexus',
          'recurse' => true,
          'require' => 'Exec[nexus-untar]',
        ) }

        it { should contain_file('/opt/sonatype-work/nexus3').with(
          'ensure'  => 'directory',
          'owner'   => 'nexus',
          'group'   => 'nexus',
          'recurse' => true,
          'require' => 'Exec[nexus-untar]',
        ) }

        it { should contain_file('/opt/nexus').with(
          'ensure'  => 'link',
          'target'  => '/opt/nexus-3.6.0-02',
          'require' => 'Exec[nexus-untar]',
        ) }

        it 'should handle deploy_pro' do
          params.merge!(
            {
              'deploy_pro'    => true,
              'download_site' => 'http://download.sonatype.com/nexus/professional-bundle'
            }
          )

          should contain_wget__fetch('nexus-professional-2.11.2-01-bundle.tar.gz').with(
            'source' => 'http://download.sonatype.com/nexus/professional-bundle/nexus-professional-2.11.2-01-bundle.tar.gz',
            'destination' => '/srv/nexus-professional-2.11.2-01-bundle.tar.gz',
          )

          should contain_exec('nexus-untar').with(
            'command' => 'tar zxf /srv/nexus-professional-2.11.2-01-bundle.tar.gz --directory /srv',
            'creates' => '/srv/nexus-professional-2.11.2-01',
          )

          should contain_file('/srv/nexus-professional-2.11.2-01')

          should contain_file('/srv/nexus').with(
            'target' => '/srv/nexus-professional-2.11.2-01',
          )
        end

        it 'should working with md5sum' do
          params.merge!(
            {
              'md5sum'        => '1234567890'
            }
          )
          should contain_wget__fetch('nexus-3.6.0-02-unix.tar.gz').with(
            'source'      => 'https://sonatype-download.global.ssl.fastly.net/nexus/3/nexus-3.6.0-02-unix.tar.gz',
            'destination' => '/opt/nexus-3.6.0-02-unix.tar.gz',
            'before'      => 'Exec[nexus-untar]',
            'source_hash' => 'c371a04067f6a83156772f54603ad58a',
          )
          should contain_exec('nexus-untar').with(
            'command' => 'tar zxf /opt/nexus-3.6.0-02-unix.tar.gz --directory /opt',
            'creates' => '/opt/nexus-3.6.0-02',
            'path'    => [ '/bin', '/usr/bin' ],
          )
        end

      end

    end
  end
end

# vim: sw=2 ts=2 sts=2 et :
