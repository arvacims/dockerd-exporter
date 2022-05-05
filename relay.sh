#!/bin/sh

set -e

DOCKER_GW_BRIDGE_IP=$(ip route list | grep 'default' | awk '{print $3}')
echo "Relaying ${DOCKER_GW_BRIDGE_IP}:${DOCKERD_METRICS_PORT} to port 80 ..."
exec socat -d -d 'TCP-L:80,fork' "TCP:${DOCKER_GW_BRIDGE_IP}:${DOCKERD_METRICS_PORT}"
