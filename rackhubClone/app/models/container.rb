class Container < ActiveRecord::Base
  has_many :ports
  belongs_to :parent, class_name: "Container", foreign_key: :parent_id
  has_many :children, class_name: "Container", foreign_key: :parent_id
  attr_accessible :image_id, :name, :ssh_port, :http_port, :http_dev_port, :repo_url

  DOCKER_URL = "http://localhost:4243"
  LOCAL = "localhost"
  LOCAL_IP = "127.0.0.1"
  REDIS_PORT = 6379
  BASE_HOST = Rails.application.config.base_host

  IMAGE_NAME = "henteko/test"

  def master_merge
    parent_con = self.parent
    new_name = parent_con.name
    parent_con.delete

    Port.set_merge_ports(self, new_name)
    self.name = new_name
    self.save
  end

  def master_clone
    con = Container.docker_create!('stg.' + self.name, self.repo_url)
    con.parent = self
    con.save
  end

  def host_name
    self.name + '.' + BASE_HOST
  end

  def delete
    result = Container.docker_kill(self.image_id)
    return nil unless result

    Port.delete_ports(self)
    self.destroy
  end

  def self.docker_create!(name, repo_url)
    container = Container.new()

    base_docker_port = Port::BASE_PORT + (Container.maximum('id') || 0)
    option = Container.git_clone(repo_url)
    port_options = Port.get_ports(option, base_docker_port)
    image_id = Container.docker_start(IMAGE_NAME, {
      ports: port_options
    })
    return nil if image_id.nil?

    container.name = name
    container.image_id = image_id
    container.repo_url = repo_url
    container.save
    Port.set_port(option, container, base_docker_port)

    return container
  end

  #### docker start
  def self.docker_start(image_name, option)
    conn = Faraday::Connection.new(:url => DOCKER_URL) do |builder|
      builder.use Faraday::Request::UrlEncoded  # リクエストパラメータを URL エンコードする
      builder.use Faraday::Response::Logger     # リクエストを標準出力に出力する
      builder.use Faraday::Adapter::NetHttp     # Net/HTTP をアダプターに使う
    end

    # search container
    response = conn.post do |req|
      req.url '/containers/create'
      req.headers['Content-Type'] = 'application/json'
      req.body = JSON.generate({
        Image: image_name
      })
    end
    container = JSON.parse(response.body)

    ports = option[:ports]
    # start container
    response = conn.post do |req|
      req.url "/containers/#{container['Id']}/start"
      req.headers['Content-Type'] = 'application/json'
      req.body = JSON.generate({
        PortBindings: ports
      })
    end

    if response.status == 204
      return container['Id']
    end
    return nil
  end

  #### docker kill
  def self.docker_kill(image_id)
    Docker.url = DOCKER_URL
    docker_container = Docker::Container.get(image_id)
    result = docker_container.kill
    return true unless result.nil?
    return false
  end

  def self.git_clone(repo_url)
    option = {}
    Dir.mktmpdir do |repo_path|
      git = Git.clone(repo_url, 'app', :path => repo_path)
      Container.docker_build(repo_path + '/app')
      option = YAML.load_file(repo_path + '/app/option.yml')
    end
    return option
  end

  def self.docker_build(path)
    Docker.url = DOCKER_URL
    image = Docker::Image.build_from_dir(path)
    image.tag('repo' => IMAGE_NAME)
  end
end
