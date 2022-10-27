FROM elastic/kibana:8.4.3

USER root

RUN apt-get update && apt-get -y install \
    curl \
    git

USER kibana
EXPOSE 5601

COPY ./docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT /docker-entrypoint.sh