class Port < ActiveRecord::Base
  belongs_to :container
  attr_accessible :docker_port, :local_port, :docker_local_port

  BASE_PORT = 10000
  
  # docker_localがdocker内で動いているport
  # local_portがsharecolle.info:5000のport
  # docker_portがシステムが決めるport
  
  def self.get_ports(option, base_docker_port)
    docker_port = base_docker_port
    port_options = {}
    ports = option['port']
    ports.keys.each_with_index do |key, index|
      docker_port += (index * 10000)
      port_options[key.to_s + '/tcp'] = [{"HostPort" => docker_port.to_s}]
    end
    return port_options
  end

  def self.get_settings(option, base_docker_port)
    docker_port = base_docker_port
    port_settings = []
    ports = option['port']
    ports.keys.each_with_index do |key, index|
      docker_port += (index * 10000)
      port_settings.push({
        local: ports[key],
        docker: docker_port,
        docker_local: key
      })
    end
    return port_settings
  end

  def self.set_port(option, container, base_docker_port)
    redis = Redis.new(:host => Container::LOCAL, :port => Container::REDIS_PORT)
    url = container.name + '.' + Container::BASE_HOST
    port_settings = Port.get_settings(option, base_docker_port)
    port_settings.each do |port_setting|
      port = Port.new
      port.local_port = port_setting[:local]
      port.docker_port = port_setting[:docker]
      port.docker_local_port = port_setting[:docker_local]
      port.container = container
      port.save

      if port.local_port == 80
        redis.set("#{url}", Container::LOCAL_IP + ':' + port.docker_port.to_s)
      elsif port.local_port == 22
        # 何もしない
      else
        redis.set("#{url}:#{port.local_port}", Container::LOCAL_IP + ':' + port.docker_port.to_s)
      end
    end
  end

  def self.delete_ports(container)
    redis = Redis.new(:host => Container::LOCAL, :port => Container::REDIS_PORT)
    url = container.host_name
    container.ports.each do |port|
      if port.local_port == 80
        redis.del(url)
      else
        redis.del(url + ':' + port.local_port.to_s)
      end
      port.destroy
    end
  end

  def self.set_merge_ports(container, new_name)
    redis = Redis.new(:host => Container::LOCAL, :port => Container::REDIS_PORT)
    url = container.host_name
    new_url = new_name + '.' + Container::BASE_HOST
    container.ports.each do |port|
      if port.local_port == 80
        ip = redis.get(url)
        redis.del(url)
        redis.set(new_url, ip)
      else
        ip = redis.get(url + ':' + port.local_port.to_s)
        redis.del(url + ':' + port.local_port.to_s)
        redis.set(new_url + ':' + port.local_port.to_s, ip)
      end
    end
  end
end
