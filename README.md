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
```bash
docker run ... -v /etc/localtime:/etc/localtime:ro
```

### Enable Gotify Notifications
If you need to recieve [Gotify](https://github.com/gotify/server/) Notifications, simply add following variables to your deployment:
```yaml
docker run -d \
    -e AUTOHEAL_CONTAINER_LABEL=all \
    -e AUTOHEAL_NOTIFICATION_GOTIFY_URL="http://gotify" \
    -e AUTOHEAL_NOTIFICATION_GOTIFY_TOKEN="xxxxxxxxxxxx"
    -v /var/run/docker.sock:/var/run/docker.sock \
    autoheal    
```

### Docker-compose
This is an example for docker compose file.
```yaml
version: "3.4"
services:
  autoheal:
    container_name: autoheal
    restart: always
    image: willfarrell/autoheal:latest
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - AUTOHEAL_CONTAINER_LABEL=autoheal
      - AUTOHEAL_INTERVAL=5
      - AUTOHEAL_NOTIFICATION_GOTIFY_URL=http://gotify
      - AUTOHEAL_NOTIFICATION_GOTIFY_TOKEN=xxxxxxxxxxxxx
```

## ENV Defaults
```yaml
AUTOHEAL_CONTAINER_LABEL=autoheal
AUTOHEAL_INTERVAL=5   # check every 5 seconds
AUTOHEAL_START_PERIOD=0   # wait 0 seconds before first health check
AUTOHEAL_DEFAULT_STOP_TIMEOUT=10   # Docker waits max 10 seconds (the Docker default) for a container to stop before killing during restarts (container overridable via label, see below)
DOCKER_SOCK=/var/run/docker.sock   # Unix socket for curl requests to Docker API
CURL_TIMEOUT=30     # --max-time seconds for curl requests to Docker API
WEBHOOK_URL=""    # post message to the webhook if a container was restarted (or restart failed)
AUTOHEAL_NOTIFICATION_GOTIFY_URL=""    # Gotify URL with protocol and Port if needed, e.g. http://gotify:8080 or https://gotify
AUTOHEAL_NOTIFICATION_GOTIFY_TOKEN=""  # Gotify Token
AUTOHEAL_NOTIFICATION_GOTIFY_TITLE="Docker Autoheal"   # Gotify Notification Title
```

### Optional Container Labels
```yaml
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
