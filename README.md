# Nexus module for Puppet [![Build Status](https://travis-ci.org/SchlegelS0208/nexus.svg?branch=master)](https://travis-ci.org/SchlegelS0208/nexus)
Install and configure Sonatype Nexus.

I created a copy based on Hubspot's puppet-nexus module,
because it seems to be not actively maintained anymore:
[![Hubspot's Module](https://github.com/hubspotdevops/puppet-nexus)]

## Requires
* maestrodev/wget
* puppetlabs/stdlib

## Usage
The following is a basic role class for building a nexus host.
Adjust accordingly as needed.

NOTE: you must pass version to Class['nexus'].  This is needed for the
download link and determining the name of the nexus directory.

echo "manifest = /tmp/puppet/manifest" >> /etc/puppet/puppet.conf 
echo "modules = /tmp/puppet/modules" >> /etc/puppet/puppet.conf 
yum install -y git java-openjdk
cd /tmp/puppet
git init
git submodule add https://github.com/puppetlabs/puppetlabs-stdlib.git modules/stdlib
git submodule add https://github.com/maestrodev/puppet-wget.git modules/wget
cd /tmp/puppet/manifests
puppet apply --pluginsync --verbose --modulepath '/tmp/puppet/modules' /tmp/puppet/manifests/default.pp 

```puppet
class role_nexus_server {

  # puppetlabs-java
  # NOTE: Nexus requires
  class{ '::java': }

  class{ '::nexus':
    version    => '2.8.0',
    revision   => '05',
    nexus_root => '/srv', # All directories and files will be relative to this
  }

  Class['::java'] ->
  Class['::nexus']
}
```

NOTE: If you wish to deploy a Nexus Pro server instead of Nexus OSS set
`deploy_pro => true`

### Usage: Nexus 3.6 support

```puppet
class role_nexus_server {

  class{ '::nexus':
    version               => '3.0.0',
    revision              => '03',
    download_site         => 'http://download.sonatype.com/nexus/3',
    nexus_type            => 'unix',
    nexus_work_dir_manage => false
  }

}
```

NOTE: If you wish to use Nexus **3**, `nexus_work_dir_manage`
need to be set to `false` because this module support **only** Nexus **3** installation

### Nginx proxy
The following is setup for using the
[jfryman/puppet-nginx](https://github.com/jfryman/puppet-nginx) module. Nexus
does not adequately support HTTP and HTTPS simultaneously.  Below forces
all connections to HTTPS.  Be sure to login after the app is up and head
to Administration -> Server.  Change the base URL to "https" and check
"Force Base URL".  The application will be available at:

https://${::fqdn}/nexus/

```puppet
  class{ '::nginx': }

  file { '/etc/nginx/conf.d/default.conf':
    ensure => absent,
    require => Class['::nginx::package'],
    notify => Class['::nginx::service']
  }

  nginx::resource::vhost { 'nexus':
    ensure            => present,
    www_root          => '/usr/share/nginx/html',
    rewrite_to_https  => true,
    ssl               => true,
    ssl_cert          => '/etc/pki/tls/certs/server.crt',
    ssl_key           => '/etc/pki/tls/private/server.key',
  }

  nginx::resource::location { 'nexus':
    ensure    => present,
    location  => '/nexus',
    vhost     => 'nexus',
    proxy     => "http://${nexus_host}:${nexus_port}/nexus",
    ssl       => true,
  }
```
## TODO
* Find a way to not require a version to be passed to Class['nexus']

## Modified by:
* Steven Schlegel <schlegels@i-fixit.it>

## Initial Authors & Copyright
* Tom McLaughlin <tmclaughlin@hubspot.com>
Hubspot, Inc.
