### docker-containers-health

Checks whether a docker container is running or not. After that an event is sent to a riemann server.

##How to run

```
$ ruby container_health.rb --url my.riemann.server --hostname host_name --container_name container --interval 5
```

Using Docker

````
$ docker build -t container-monitoring .
$ docker run --name ric -d -e RIEMANN_SERVER=my.riemann.server -e HOST_NAME=hostname -e CONTAINER_NAME=docker_container_name -e INTERVAL=5 container-monitoring
```

