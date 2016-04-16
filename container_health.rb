require 'riemann/client'

RIEMANN_SERVER = ARGV[0]
HOSTNAME = ARGV[1]
CONTAINER_NAME = ARGV[2]

riemann_client = Riemann::Client.new host: RIEMANN_SERVER, port: 5555, timeout: 5

while true
  container_id = %x[docker ps | grep #{CONTAINER_NAME} | awk '{print $1}'].chop
  is_running = system("docker inspect -f {{.State.Running}} " << container_id)
  container_state = is_running ? "ok" : "critical"
  metric = is_running ? 1 : 0

  riemann_client << {
    host: HOSTNAME,
    service: "docker container health",
    state: container_state,
    metric: metric
  }

  p "send event. Container state: #{container_state}"

  sleep(120)
end
