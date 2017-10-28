# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  #config.vm.box = "puppetlabs/centos-6.6-64-puppet"
  config.vm.box = "puppetlabs/ubuntu-14.04-64-nocm"
  config.vm.box_version = "1.0.1"
  config.vm.provision :file, source: "/home/sschlegel-lc/github/nexus/puppet/manifests", destination: "/tmp/puppet/manifests"
  config.vm.provision :file, source: "/home/sschlegel-lc/github/nexus/manifests", destination: "/tmp/puppet/modules/nexus/manifests"
  config.vm.provision :file, source: "/home/sschlegel-lc/github/nexus/templates", destination: "/tmp/puppet/modules/nexus/templates"
#  config.vm.provision "puppet" do |puppet|
#    puppet.manifests_path = ["vm","/tmp/puppet/manifests"]
#    puppet.manifest_file  = "default.pp"
  #  puppet.working_directory = "/tmp/puppet"
  #  puppet.options = "--verbose"
#  end
  config.vm.define "nexus-testBox" do |foohost|
  end
  config.vm.network "private_network", ip: "192.168.177.233"
  config.vm.provider :virtualbox do |vb|
     vb.name = "nexus-vgBox"
  end
end
