# Class: redis::params
#
# This class configures parameters for the puppet-redis module.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class redis::params {

  case $::operatingsystem {
    'centos', 'redhat', 'fedora': {
      $package = 'redis'
      $service = 'redis'
      $conf    = '/etc/redis.conf'
    }
    'ubuntu', 'debian': {
      $package = 'redis-server'
      $service = 'redis-server'
      $conf    = '/etc/redis/redis.conf'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} only support osfamily RedHat and Debian")
    }
  }

}
