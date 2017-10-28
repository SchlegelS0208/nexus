### NEXUS Server Installation -- for Nexus 3.x.x ONLY!!!
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
    download_site         => 'https://sonatype-download.global.ssl.fastly.net/nexus/3',
    nexus_type            => 'unix',
    nexus_work_dir_manage => false,
    nexus_root            => '/opt',
    download_folder       => '/opt',
  }
}
