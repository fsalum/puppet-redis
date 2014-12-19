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
    'debian': {
      $service        = 'redis-sentinel'
      $conf_dir       = '/etc/redis'
      $conf           = '/etc/redis/sentinel.conf'
      $conf_logrotate = '/etc/logrotate.d/redis-sentinel'
      $pidfile        = '/var/run/redis/redis-sentinel.pid'
      $logfile        = '/var/log/redis/redis-sentinel.log'
      $upstart_script = '/etc/init/redis-sentinel.conf'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only support osfamily Debian")
    }
  }

}
