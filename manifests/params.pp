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
      $package       = 'redis'
      $service       = 'redis'
      $conf          = '/etc/redis.conf'
      $conf_template = 'redis.rhel.conf.erb'
      $pidfile       = '/var/run/redis/redis.pid'
      $logfile       = '/var/log/redis/redis.log'
    }
    'ubuntu', 'debian': {
      $package       = 'redis-server'
      $service       = 'redis-server'
      $conf          = '/etc/redis/redis.conf'
      $conf_template = 'redis.debian.conf.erb'
      $pidfile       = '/var/run/redis.pid'
      $logfile       = '/var/log/redis/redis-server.log'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} only support osfamily RedHat and Debian")
    }
  }

}
