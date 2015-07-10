# Class: redis::sentinel_params
#
# This class configures sentinel parameters for the puppet-redis module.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class redis::sentinel_params {

  case $::osfamily {
    'RedHat': {
      $package        = 'redis'
      $service        = 'redis-sentinel'
      $conf           = '/etc/sentinel.conf'
      $conf_dir       = undef
      $conf_logrotate = '/etc/logrotate.d/sentinel'
      $pidfile        = '/var/run/redis/sentinel.pid'
      $logfile        = '/var/log/redis/sentinel.log'
      $script         = '/etc/init.d/redis-sentinel'
      $template       = 'redis/sentinel-systemd.conf.erb'
    }
    'debian': {
      $package        = 'redis-server'
      $service        = 'redis-sentinel'
      $conf_dir       = '/etc/redis'
      $conf           = '/etc/redis/sentinel.conf'
      $conf_logrotate = '/etc/logrotate.d/redis-sentinel'
      $pidfile        = '/var/run/redis/redis-sentinel.pid'
      $logfile        = '/var/log/redis/redis-sentinel.log'
      $script         = '/etc/init.d/redis-sentinel'
      $template       = 'redis/sentinel-init.conf.erb'

    }
    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only support osfamily RedHat and Debian")
    }
  }

}
