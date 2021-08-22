# Docker Autoheal

Monitor and restart unhealthy docker containers. 
This functionality was proposed to be included with the addition of `HEALTHCHECK`, however didn't make the cut.
This container is a stand-in till there is native support for `--exit-on-unhealthy` https://github.com/docker/docker/pull/22719.

## Supported tags and Dockerfile links
- [`latest` (*Dockerfile*)](https://github.com/willfarrell/docker-autoheal/blob/main/Dockerfile) - Built daily
- [`1.1.0` (*Dockerfile*)](https://github.com/willfarrell/docker-autoheal/blob/1.1.0/Dockerfile)
- [`v0.7.0` (*Dockerfile*)](https://github.com/willfarrell/docker-autoheal/blob/v0.7.0/Dockerfile)

![](https://img.shields.io/docker/pulls/willfarrell/autoheal "Total docker pulls") [![](https://images.microbadger.com/badges/image/willfarrell/autoheal.svg)](http://microbadger.com/images/willfarrell/autoheal "Docker layer breakdown")

## How to use
### UNIX socket passthrough
```bash
docker run -d \
    --name autoheal \
    --restart=always \
    -e AUTOHEAL_CONTAINER_LABEL=all \
    -v /var/run/docker.sock:/var/run/docker.sock \
    willfarrell/autoheal
```
### TCP socket
```bash
docker run -d \
    --name autoheal \
    --restart=always \
    -e AUTOHEAL_CONTAINER_LABEL=all \
    -e DOCKER_SOCK=tcp://HOST:PORT \
    -v /path/to/certs/:/certs/:ro \
    willfarrell/autoheal
```

## UNIX socket passthrough & Gotify Notification

```
docker run -d \
    --name autoheal \
    --restart=always \
    -e AUTOHEAL_CONTAINER_LABEL=all \
    -e AUTOHEAL_NOTIFICATIONS=gotify \
    -e AUTOHEAL_NOTIFICATIONS_GOTIFY_PRIORITY=5 \
    -e AUTOHEAL_NOTIFICATIONS_GOTIFY_URL=http://gotify \
    -e AUTOHEAL_NOTIFICATIONS_GOTIFY_TOKEN=YOUR_GOTIFY_TOKEN \
    -v /var/run/docker.sock:/var/run/docker.sock \
    willfarrell/autoheal

```

a) Apply the label `autoheal=true` to your container to have it watched.

b) Set ENV `AUTOHEAL_CONTAINER_LABEL=all` to watch all running containers. 

c) Set ENV `AUTOHEAL_CONTAINER_LABEL` to existing label name that has the value `true`.

Note: You must apply `HEALTHCHECK` to your docker images first. See https://docs.docker.com/engine/reference/builder/#healthcheck for details.
See https://docs.docker.com/engine/security/https/ for how to configure TCP with mTLS

The certificates, and keys need these names:
* ca.pem
* client-cert.pem
* client-key.pem

### Change Timezone
If you need the timezone to match the local machine, you can map the `/etc/localtime` into the container.
```
docker run ... -v /etc/localtime:/etc/localtime:ro
```


## ENV Defaults
```
AUTOHEAL_CONTAINER_LABEL=autoheal
AUTOHEAL_INTERVAL=5   # check every 5 seconds
AUTOHEAL_START_PERIOD=0   # wait 0 seconds before first health check
AUTOHEAL_DEFAULT_STOP_TIMEOUT=10   # Docker waits max 10 seconds (the Docker default) for a container to stop before killing during restarts (container overridable via label, see below)
DOCKER_SOCK=/var/run/docker.sock   # Unix socket for curl requests to Docker API
CURL_TIMEOUT=30     # --max-time seconds for curl requests to Docker API
AUTOHEAL_NOTIFICATIONS=false # Disable Webhook notification ( Only Logs )
AUTOHEAL_NOTIFICATIONS_GOTIFY_PRIORITY=5 # Priority of Gotify notification
AUTOHEAL_NOTIFICATIONS_GOTIFY_URL=http://gotify # URL of Gotify server ( no trailing slash )
AUTOHEAL_NOTIFICATIONS_GOTIFY_TOKEN=YOUR_GOTIFY_TOKEN # Token of Gotify App
```

### Optional Container Labels
```
autoheal.stop.timeout=20        # Per containers override for stop timeout seconds during restart
```

## Testing
```bash
docker build -t autoheal .

docker run -d \
    -e AUTOHEAL_CONTAINER_LABEL=all \
    -v /var/run/docker.sock:/var/run/docker.sock \
    autoheal                                                                        
```
