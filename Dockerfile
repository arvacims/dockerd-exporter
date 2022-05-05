FROM alpine:3.15

RUN apk add --no-cache socat

ENV DOCKERD_METRICS_PORT="9323"

COPY relay.sh /opt/dockerd-exporter/relay.sh
WORKDIR /opt/dockerd-exporter

CMD ./relay.sh
