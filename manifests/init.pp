# == Class: redis
#
# Install and configure a Redis server
#
# === Parameters
#
# All the redis.conf parameters can be passed to the class.
# See below for a complete list of parameters accepted.
#
# Check the README.md file for any further information about parameters for this class.
#
# === Examples
#
#  class { redis:
#    conf_port => '6380',
#    conf_bind => '0.0.0.0',
#  }
#
# === Authors
#
# Felipe Salum <fsalum@gmail.com>
#
# === Copyright
#
# Copyright 2013 Felipe Salum, unless otherwise noted.
#
class redis (
  $package_ensure                   = 'present',
  $service_ensure                   = 'running',
  $service_enable                   = true,
  $service_restart                  = true,
  $system_sysctl                    = false,
  $conf_daemonize                   = 'yes',
  $conf_pidfile                     = undef,
  $conf_port                        = '6379',
  $conf_bind                        = '0.0.0.0',
  $conf_timeout                     = '0',
  $conf_loglevel                    = 'notice',
  $conf_logfile                     = undef,
  $conf_syslog_enabled              = undef,
  $conf_syslog_ident                = undef,
  $conf_syslog_facility             = undef,
  $conf_databases                   = '16',
  $conf_save                        = undef,
  $conf_nosave                      = undef,
  $conf_rdbcompression              = 'yes',
  $conf_dbfilename                  = 'dump.rdb',
  $conf_dir                         = '/var/lib/redis/',
  $conf_slaveof                     = undef,
  $conf_masterauth                  = undef,
  $conf_slave_server_stale_data     = 'yes',
  $conf_repl_ping_slave_period      = '10',
  $conf_repl_timeout                = '60',
  $conf_requirepass                 = undef,
  $conf_maxclients                  = undef,
  $conf_maxmemory                   = undef,
  $conf_maxmemory_policy            = undef,
  $conf_maxmemory_samples           = undef,
  $conf_appendonly                  = 'no',
  $conf_appendfilename              = undef,
  $conf_appendfsync                 = 'everysec',
  $conf_no_appendfsync_on_rewrite   = 'no',
  $conf_auto_aof_rewrite_percentage = '100',
  $conf_auto_aof_rewrite_min_size   = '64mb',
  $conf_slowlog_log_slower_than     = '10000',
  $conf_slowlog_max_len             = '1024',
  $conf_vm_enabled                  = 'no',
  $conf_vm_swap_file                = '/tmp/redis.swap',
  $conf_vm_max_memory               = '0',
  $conf_vm_page_size                = '32',
  $conf_vm_pages                    = '134217728',
  $conf_vm_max_threads              = '4',
  $conf_hash_max_zipmap_entries     = '512',
  $conf_hash_max_zipmap_value       = '64',
  $conf_list_max_ziplist_entries    = '512',
  $conf_list_max_ziplist_value      = '64',
  $conf_set_max_intset_entries      = '512',
  $conf_zset_max_ziplist_entries    = '128',
  $conf_zset_max_ziplist_value      = '64',
  $conf_activerehashing             = 'yes',
  $conf_include                     = undef,
  $conf_glueoutputbuf               = undef,
) {

  include redis::params

  $conf_template  = $redis::params::conf_template
  $conf_redis     = $redis::params::conf
  $conf_logrotate = $redis::params::conf_logrotate
  $package        = $redis::params::package
  $service        = $redis::params::service

  if $conf_pidfile {
    $conf_pidfile_real = $conf_pidfile
  }else{
    $conf_pidfile_real = $::redis::params::pidfile
  }

  if $conf_logfile {
    $conf_logfile_real = $conf_logfile
  }else{
    $conf_logfile_real = $::redis::params::logfile
  }

  package { 'redis':
    ensure => $package_ensure,
    name   => $package,
  }

  service { 'redis':
    ensure     => $service_ensure,
    name       => $service,
    enable     => $service_enable,
    hasrestart => true,
    hasstatus  => true,
    require    => [ Package['redis'],
                    Exec[$conf_dir],
                    File[$conf_redis] ],
  }

  file { $conf_redis:
    path    => $conf_redis,
    content => template("redis/${conf_template}"),
    owner   => root,
    group   => root,
    mode    => '0644',
    require => Package['redis'],
  }

  file { $conf_logrotate:
    path    => $conf_logrotate,
    content => template('redis/redis.logrotate.erb'),
    owner   => root,
    group   => root,
    mode    => '0644',
  }

  exec { $conf_dir:
    path    => '/bin:/usr/bin:/sbin:/usr/sbin',
    command => "mkdir -p ${conf_dir}",
    user    => root,
    group   => root,
    creates => $conf_dir,
    before  => Service['redis'],
    require => Package['redis'],
  }

  file { $conf_dir:
    ensure  => directory,
    owner   => redis,
    group   => redis,
    mode    => 0755,
    before  => Service['redis'],
    require => Exec[$conf_dir],
  }

  if ( $system_sysctl == true ) {
    # add necessary kernel parameters
    # see the redis admin guide here: http://redis.io/topics/admin
    sysctl { 'vm.overcommit_memory': value => '1' }
  }

  if $service_restart == true {
    # https://github.com/fsalum/puppet-redis/pull/28
    Exec[$conf_dir] ~> Service['redis']
    File[$conf_redis] ~> Service['redis']
  }

}
