require 'spec_helper_acceptance'

describe 'nexus class' do

  context 'download folder parameter' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
      node default {
        notify { 'Preparing installation of Nexus OSS': }
      
        if $::operatingsystem == 'Debian' or $::operatingsystem == 'Ubuntu' {
          class { 'jdk_oracle':
            jce            => true,
            version_update => '151',
            version_build  => '12',
            version_hash   => 'e758a0de34e24606bca991d704f6dcbf',
            default_java   => true,
            before         => Class['nexus'],
          }
        } else {
          class { 'java':
            before         => Class['nexus'],
          }
        }
      
        notify { 'Running installation procedure of Nexus OSS': }
        class { 'nexus':
          version               => '3.6.0',
          revision              => '02',
          nexus_root            => '/opt',
          download_folder       => '/opt',
        }
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_failures => true)
    end

    describe user('nexus') do
      it { should belong_to_group 'nexus' }
    end

    describe service('nexus') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    context 'Nexus should be running on the default port' do
      describe port(8081) do
        it {
          sleep(120) # Waiting start up
          should be_listening
        }
      end
      describe command('curl 0.0.0.0:8081/nexus/') do
        its(:stdout) { should match /Nexus Repository Manager/ }
      end
    end

  end
end
