require 'facter'

Facter.add("redis_port", :timeout => 120) do
    confine :osfamily => "Debian"

    setcode do
        redis_port = nil
        if File.exists?("/etc/redis/redis.conf")
            redis_port_grep = Facter::Util::Resolution.exec("grep '^port' /etc/redis/redis.conf | awk '{print $2}'")
            if redis_port_grep =~ /^\d+$/
                redis_port = redis_port_grep
            end
        end
        redis_port
    end
end

Facter.add("redis_port", :timeout => 120) do
    confine :osfamily => "RedHat"

    setcode do
        redis_port = nil
        if File.exists?("/etc/redis.conf")
            redis_port_grep = Facter::Util::Resolution.exec("grep '^port' /etc/redis.conf | awk '{print $2}'")
            if redis_port_grep =~ /^\d+$/
                redis_port = redis_port_grep
            end
        end
        redis_port
    end
end
