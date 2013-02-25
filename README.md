Redis Module for Puppet
=======================

This module install and maneges the Redis server. All redis.conf options are
accepted in the parameterized class.

Quick Start
-----------

Use the default parameters:

    class { 'redis': }

To change the port and listening network interface:

    class { 'redis':
      conf_port            => '6379',
      conf_bind            => '0.0.0.0',
    }

Parameters
----------

Check the init.pp file for a list of parameters accepted.

Author
------
Felipe Salum <fsalum@gmail.com>
