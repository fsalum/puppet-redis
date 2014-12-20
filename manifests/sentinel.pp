# == Class: redis::sentinel
#
# Install and configure a Redis Sentinel
#
# === Parameters
#
# All the sentinel.conf parameters can be passed to the class.
# See below for a complete list of parameters accepted.
#
# Check the README.md file for any further information about parameters for this class.
#
# === Examples
#
#  class { redis::sentinel:
#    conf_port      => '26379',
#    sentinel_confs => {
#      'mymaster' => {
#        'monitor'                 => '127.0.0.1 6379 2',
#        'down-after-milliseconds' => '60000',
#        'notification-script'     => '/etc/redis/scripts/thescript.py',
#        'parallel-syncs'          => '3',
#      }
#      'resque' => {
#        'monitor'                 => 'resque 6379 4',
#        'down-after-milliseconds' => '10000',
#        'failover-timeout'        => 180000,
#        'notification-script'     => '/etc/redis/scripts/thescript.py',
#        'parallel-syncs'          => '5',
#      }
#    }
#  }
#
# === Authors
#
# Victor Garcia <bravejolie@gmail.com>
#
# === Copyright
#
# Copyright 2013 Felipe Salum, unless otherwise noted.
#
class redis::sentinel (
  $conf_port                = '26379',
  $conf_daemonize           = 'yes',
  $sentinel_confs           = [],
  $service_enable           = true,
  $service_ensure           = 'running',
  $service_restart          = true,
  $manage_upstart_scripts   = true,
  $package_name             = undef,
) {

  include redis::sentinel_params

  $conf_sentinel      = $redis::sentinel_params::conf
  $conf_sentinel_orig = "${conf_sentinel}.puppet"
  $conf_logrotate     = $redis::sentinel_params::conf_logrotate
  $service            = $redis::sentinel_params::service
  $upstart_script     = $redis::sentinel_params::upstart_script

  if $package_name {
    $package     = $package_name
  }else{
    $package      = $redis::sentinel_params::package
  }

  if $conf_pidfile {
    $conf_pidfile_real = $conf_pidfile
  }else{
    $conf_pidfile_real = $::redis::sentinel_params::pidfile
  }
  if $conf_logfile {
    $conf_logfile_real = $conf_logfile
  }else{
    $conf_logfile_real = $::redis::sentinel_params::logfile
  }

  package { 'redis':
    ensure => $package_ensure,
    name   => $package,
  }

  if $manage_upstart_scripts == true {
    service { 'sentinel':
      ensure     => $service_ensure,
      name       => $service,
      hasrestart => true,
      hasstatus  => true,
      require    => [ File[$conf_sentinel_orig],
                      File[$upstart_script] ],
      provider   => 'upstart'
    }
  } else {
    service { 'sentinel':
      ensure     => $service_ensure,
      name       => $service,
      enable     => $service_enable,
      hasrestart => true,
      hasstatus  => true,
      require    => [ Package['redis'],
                      File[$conf_sentinel_orig] ],
    }
  }

  # Sentinel rewrites the config file so, to avoid overriding it
  # with the original content everytime puppet runs, this manages the
  # "notify" event on an original file that triggers a copy to the good one
  # only if it changed.
  file { $conf_sentinel_orig:
    content => template('redis/sentinel.conf.erb'),
    owner   => redis,
    group   => redis,
    mode    => '0644',
    require => Package['redis'],
    notify  => Exec["cp ${conf_sentinel_orig} ${conf_sentinel}"],
  }

  file { $conf_sentinel:
    owner   => redis,
    group   => redis,
    require => Package['redis'],
  }

  exec { "cp ${conf_sentinel_orig} ${conf_sentinel}":
    path        => '/bin:/usr/bin:/sbin:/usr/sbin',
    refreshonly => true,
    user        => redis,
    group       => redis,
    notify      => Service['sentinel'],
    require     => File[$conf_sentinel],
  }

  file { $conf_logrotate:
    path    => $conf_logrotate,
    content => template('redis/logrotate.erb'),
    owner   => root,
    group   => root,
    mode    => '0644',
  }

  if $service_restart == true {
    # https://github.com/fsalum/puppet-redis/pull/28
    File[$conf_sentinel_orig] ~> Service['sentinel']
  }

  if $manage_upstart_scripts == true {
    file { $upstart_script:
      ensure  => present,
      content => template('redis/sentinel-init.conf.erb'),
    }
  }

}
