require 'facter'
Facter.add("redis_version") do
  setcode do
      redis_verison = nil
      # get the current version of redis
      case Facter.value('osfamily')
      when "RedHat"
        redis_version = Facter::Util::Resolution.exec('/usr/sbin/redis-server --version')

      when "Debian"
        redis_version = Facter::Util::Resolution.exec('/usr/bin/redis-server --version')
      end

      case redis_version
        when /2\.4\.[0-9]/
          #set version to 2.4
          redis_version = '2.4.x'
        when /v\=2\.6\.[0-9]/
          #set version to 2.6
          redis_version = '2.6.x'
        when /v\=2\.8\.[0-9]/
          #set version to 2.8
          redis_version = '2.8.x'
        else
          redis_version = 'nil'
      end
      redis_version
  end
end
