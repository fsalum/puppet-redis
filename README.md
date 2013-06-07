Redis Module for Puppet
=======================
[![Build Status](https://secure.travis-ci.org/fsalum/puppet-redis.png)](http://travis-ci.org/fsalum/puppet-redis)

This module install and manages the Redis server. All redis.conf options are
accepted in the parameterized class.

Operating System
----------------

Tested on CentOS 6.3 and Debian Squeeze.

Quick Start
-----------

Use the default parameters:

    class { 'redis': }

To change the port and listening network interface:

    class { 'redis':
      conf_port => '6379',
      conf_bind => '0.0.0.0',
    }

Parameters
----------

Check the [init.pp](https://github.com/fsalum/puppet-redis/blob/master/manifests/init.pp) file for a list of parameters accepted.

Author
------
Felipe Salum <fsalum@gmail.com>
