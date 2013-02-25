node default {

  class { 'redis':
    conf_port            => '6379',
    conf_bind            => '0.0.0.0',
  }

}
