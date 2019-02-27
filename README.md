# docker-autoheal

Monitor and restart unhealthy docker containers. 
This functionality was proposed to be included with the addition of `HEALTHCHECK`, however didn't make the cut.
This container is a stand-in till there is native support for `--exit-on-unhealthy` https://github.com/docker/docker/pull/22719.

[![](https://img.shields.io/docker/pulls/willfarrell/autoheal.svg)](https://hub.docker.com/r/willfarrell/autoheal)  [![](https://images.microbadger.com/badges/image/willfarrell/autoheal.svg)](http://microbadger.com/images/willfarrell/autoheal)


## Supported tags and Dockerfile links
- [`1.0.0`,`1.0`,`1`,`latest` (*Dockerfile*)](https://github.com/willfarrell/docker-autoheal/blob/master/Dockerfile)
- [`1.0.0-x86_64`,`1.0-x86_64`,`1-x86_64`,`x86_64`(*Dockerfile*)](https://github.com/willfarrell/docker-autoheal/blob/master/Dockerfile)
- [`1.0.0-amd64`,`1.0-amd64`,`1-amd64`,`amd64` (*Dockerfile*)](https://github.com/willfarrell/docker-autoheal/blob/master/Dockerfile)
- [`1.0.0-arm32v6`,`1.0-arm32v6`,`1-arm32v6`,`arm32v6` (*Dockerfile*)](https://github.com/willfarrell/docker-autoheal/blob/master/Dockerfile)
- [`1.0.0-arm64v8`,`1.0-arm64v8`,`11-arm64v8`,`arm64v8` (*Dockerfile*)](https://github.com/willfarrell/docker-autoheal/blob/master/Dockerfile)
- [`1.0.0-i386`,`1.0-i386`,`1-i386`,`i386` (*Dockerfile*)](https://github.com/willfarrell/docker-autoheal/blob/master/Dockerfile)
- [`1.0.0-ppc64le`,`1.0-ppc64le`,`1-ppc64le`,`ppc64le` (*Dockerfile*)](https://github.com/willfarrell/docker-autoheal/blob/master/Dockerfile)

## How to use
a) Apply the label `autoheal=true` to your container to have it watched.

```bash
docker run -d \
    --name autoheal \
    --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    willfarrell/autoheal

docker run -d --name app \
    --label autoheal=true \
    example/app
```

b) Set ENV `AUTOHEAL_CONTAINER_LABEL=all` to watch all running containers. 

```bash
docker run -d \
    --name autoheal \
    --restart=always \
    -e AUTOHEAL_CONTAINER_LABEL=all \
    -v /var/run/docker.sock:/var/run/docker.sock \
    willfarrell/autoheal
    
docker run -d --name app1 \
    --label autoheal=true
docker run -d --name app2 \
    --label autoheal=true
```

c) Set ENV `AUTOHEAL_CONTAINER_LABEL` to existing label name that has the value `true`.

```bash
docker run -d \
    --name autoheal \
    --restart=always \
    -e AUTOHEAL_CONTAINER_LABEL=production \
    -v /var/run/docker.sock:/var/run/docker.sock \
    willfarrell/autoheal
    
docker run -d --name app \
    --label production=true \
    example/app


```

Note: You must apply `HEALTHCHECK` to your docker images first. See https://docs.docker.com/engine/reference/builder/#healthcheck for details.

## ENV Defaults
```
AUTOHEAL_CONTAINER_LABEL=autoheal  # label on container to watch, see above for examples
AUTOHEAL_INTERVAL=5                # check every 5 seconds
AUTOHEAL_START_PERIOD=0            # wait 0 seconds before first health check
AUTOHEAL_DEFAULT_STOP_TIMEOUT=10   # Docker waits max 10 seconds (the Docker default) for a container to stop before killing during restarts (container overridable via label, see below)
DOCKER_SOCK=/var/run/docker.sock   # Unix socket for curl requests to Docker API
CURL_TIMEOUT=30                    # --max-time seconds for curl requests to Docker API
```

### Optional Container Labels
```
autoheal.stop.timeout=20        # Per containers override for stop timeout seconds during restart
```

## Testing
```bash
docker build -t autoheal .

docker run --rm -d --name autoheal \
    -v /var/run/docker.sock:/var/run/docker.sock \
    autoheal                                                                       
  
docker build -t unhealthy ./test  
docker run --rm -d --name unhealthy --label autoheal=true unhealthy 
```
