node default {

  case $::osfamily {
    'RedHat': {
      package { 'epel-release':
        ensure   => present,
        source   => 'http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm',
        provider => rpm,
        before   => Class['redis'],
      }
    }
    'Debian': {
      # redis is on repository
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} only support osfamily RedHat and Debian")
    }
  }

  class { 'redis':
    conf_port     => '6379',
    conf_bind     => '0.0.0.0',
    system_sysctl => true,
  }

}
