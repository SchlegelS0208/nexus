require 'beaker-rspec'
require 'beaker/puppet_install_helper'

# Install Puppet
unless ENV['RS_PROVISION'] == 'no'
  run_puppet_install_helper
end

UNSUPPORTED_PLATFORMS = ['RedHat','Suse','windows','AIX','Solaris']

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(:source => proj_root, :module_name => 'nexus')
    hosts.each do |host|
      shell("/bin/touch #{default['puppetpath']}/hiera.yaml")
      shell('puppet module install puppetlabs-stdlib', { :acceptable_exit_codes => [0,1] })
      if fact('osfamily') == 'Debian'
          shell('puppet module install tylerwalts-jdk_oracle -v 2.0.0', { :acceptable_exit_codes => [0,1] })
      else
          shell('puppet module install puppetlabs-java -v 1.6.0', { :acceptable_exit_codes => [0,1] })
      end
      shell('puppet module install maestrodev-wget', { :acceptable_exit_codes => [0,1] })
    end
  end
end
