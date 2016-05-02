FROM ruby:2.2

RUN gem install riemann-client
RUN gem install trollop

CMD ruby container_health.rb --url ${RIEMANN_SERVER} --hostname {HOST_NAME} --container_name ${CONTAINER_NAME} --interval ${INTERVAL}
