# For serverspec documentation - see http://serverspec.org/tutorial.html
require_relative '../spec_helper'

describe package('redis-server') do
  it { should be_installed }
end

describe service('redis-server') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/redis/redis.conf') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode '644' }
end

describe file('/etc/logrotate.d/redis-server') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode '644' }
end

describe file('/var/lib/redis/') do
  it { should be_directory }
  it { should be_owned_by 'redis' }
  it { should be_grouped_into 'redis' }
  it { should be_mode '755' }
end

describe command('redis-cli --version') do
  it { should return_exit_status 0 }
  it { should return_stdout /^redis-cli.*/ }
end

describe linux_kernel_parameter('vm.overcommit_memory') do 
  its(:value) { should eq 1 }
end
