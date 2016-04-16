require 'riemann/client'

RIEMANN_SERVER = ARGV[0]
HOSTNAME = ARGV[1]
CONTAINER_NAME = ARGV[2]

riemann_client = Riemann::Client.new host: RIEMANN_SERVER, port: 5555, timeout: 5

while true

  begin
    riemann_client['true']
  rescue Riemann::Client::TcpSocket::Error
    riemann_client = Riemann::Client.new host: RIEMANN_SERVER, port: 5555, timeout: 5
    p "reconnecting..."
  end

  container_id = %x[sudo docker inspect --format '{{ .Id }}' #{CONTAINER_NAME}].chop
  is_running = system("sudo docker inspect -f {{.State.Running}} " << container_id)
  container_state = is_running ? "ok" : "critical"
  metric = is_running ? 1 : 0

  riemann_client << {
    host: HOSTNAME,
    service: "docker container health",
    state: container_state,
    metric: metric,
    tags: ["docker"]
  }

  p "Event sent. Container state: #{container_state}"

  sleep(2)
end
