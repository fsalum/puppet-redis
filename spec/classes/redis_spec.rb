# for rspec-puppet documentation - see http://rspec-puppet.com/tutorial/
require_relative '../spec_helper'

describe 'redis' do
  let(:facts) { {:operatingsystem  => 'ubuntu'} }

  it { should contain_class('redis::params') }

  it do
    should contain_package('redis').with(
      'ensure'  =>  'present',
      'name'    =>  'redis-server',
    )
  end

  it do
    should contain_service('redis').with(
      'ensure'      =>  'running',
      'name'        =>  'redis-server',
      'enable'      =>  'true',
      'hasrestart'  =>  'true',
    )
  end

  it do
    should contain_file('/etc/redis/redis.conf').with(
      'path'  =>  '/etc/redis/redis.conf',
      'owner' =>  'root',
      'group' =>  'root',
      'mode'  =>  '0644',
    )
  end

  it do
    should contain_file('/etc/logrotate.d/redis-server').with(
      'path'  =>  '/etc/logrotate.d/redis-server',
      'owner' =>  'root',
      'group' =>  'root',
      'mode'  =>  '0644',
    )
  end

  it do
    should contain_exec('/var/lib/redis/').with(
      'path'    =>  '/bin:/usr/bin:/sbin:/usr/sbin',
      'command' =>  'mkdir -p /var/lib/redis/',
      'user'    =>  'root',
      'group'   =>  'root',
      'creates' =>  '/var/lib/redis/',
    )
  end

  it do
    should contain_file('/var/lib/redis/').with(
      'ensure' =>  'directory',
      'owner'  =>  'redis',
      'group'  =>  'redis',
      'mode'   =>  '0755',
    )
  end

end
