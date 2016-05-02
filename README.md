### docker-containers-health

Checks whether a docker container is running or not. After that an event is sent to a riemann server.

##How to run

```
$ ruby container_health.rb --url my.riemann.server --hostname host_name --container_name container --interval 5
```



