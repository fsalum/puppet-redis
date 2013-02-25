node default {

  class { 'redis':
    redis_package_ensure => 'present',
    redis_service_ensure => 'running',
    redis_service_enable => true,
    conf_port            => '6379',
    conf_bind            => '0.0.0.0',
  }

}
