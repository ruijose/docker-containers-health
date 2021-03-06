require 'riemann/client'
require 'trollop'

class DockerContainerStatus
  attr_reader :uri, :interval, :container_name, :host_name, :riemann
  def initialize
    args = command_line_args
    @host_name = args[:hostname]
    @uri = args[:url]
    @interval = args[:interval]
    @container_name = args[:containername]
  end

  def send_events
    while true
      riemann_client
      container_state = is_running == "true" ? "ok" : "critical"
      metric = is_running == "true" ? 1 : 0
      send_riemann_event(container_state, metric)
      sleep(interval.to_i)
    end
  end

  private

  def command_line_args
    Trollop::options do
      opt :hostname, "server name", :type => :string
      opt :url, "Riemann server url", :type => :string
      opt :interval, "Stats page", :type => :string
      opt :containername, "Docker container name", :type => :string
    end
  end

  def riemann_client
    @riemann ||= Riemann::Client.new host: uri, port: 5555, timeout: 5
  end

  def send_riemann_event(container_state, metric)
    riemann << {
      host: host_name,
      service: "docker container health",
      state: container_state,
      metric: metric,
      tags: ["#{host_name}", "containers status"]
    }
  end

  def is_running
    %x[sudo docker inspect -f {{.State.Running}} #{get_container_id}].chop
  end

  def get_container_id
    %x[sudo docker inspect --format '{{ .Id }}' #{container_name}].chop
  end
end

DockerContainerStatus.new.send_events
