# dockerd-exporter: Prometheus exporter for Docker daemon metrics

This container relays TCP connections to the Docker daemon's metrics endpoint via the `docker_gwbridge` bridge network.

As a result, these metrics can be scraped via Prometheus instances deployed to the same overlay network.

## Docker Engine

Create or edit `/etc/docker/daemon.json` to enable the experimental features and configure the metrics address:

~~~
{
  "metrics-addr": "0.0.0.0:9323",
  "experimental": true
}
~~~

Restart the Docker service afterwards. Do the same for each node in your Docker Swarm cluster.

## Docker Swarm

Create an overlay network:

~~~sh
docker network create --driver overlay example-net
~~~

Create a global service:

~~~sh
docker service create \
  --detach \
  --mode global \
  --name dockerd-exporter \
  --network example-net \
  dockerd-exporter:latest
~~~

Configure Prometheus to scrape the _dockerd-exporter_ instances:

~~~
scrape_configs:
  - job_name: "dockerd-exporter"
    dns_sd_configs:
      - names:
          - "tasks.dockerd-exporter"
        type: "A"
~~~

Run Prometheus on the same overlay network as _dockerd-exporter_.

## Troubleshooting

You may need to open `9323/tcp` in each node's firewall.
