### docker-containers-health

Checks whether a container is running or not. After that an event is sent to a riemann server.

##How to run

```
$ ruby container_health.rb my.riemann.server hostname container_name
```
