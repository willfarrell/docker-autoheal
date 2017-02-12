# docker-autoheal

Monitor and restart unhealthy docker containers.

## Supported tags and Dockerfile links
- [`latest` (*Dockerfile*)](https://github.com/willfarrell/docker-autoheal/blob/master/Dockerfile)

[![](https://images.microbadger.com/badges/version/willfarrell/autoheal.svg)](http://microbadger.com/images/willfarrell/autoheal "Get your own version badge on microbadger.com")  [![](https://images.microbadger.com/badges/image/willfarrell/autoheal.svg)](http://microbadger.com/images/willfarrell/autoheal "Get your own image badge on microbadger.com")

## How to use
a) Apply the label `autoheal=true` to your container to have it watched.

b) Set ENV `AUTOHEAL_CONTAINER_LABEL=all` to watch all running containers. 

c) Set ENV `AUTOHEAL_CONTAINER_LABEL` to existing label name that has the value `true`.

Note: You must apply `HEALTHCHECK` to your docker images first. See https://docs.docker.com/engine/reference/builder/#/healthcheck for details.

## ENV Defaults
```
AUTOHEAL_CONTAINER_LABEL=autoheal
AUTOHEAL_INTERVAL=5
```

## Testing
```bash
docker build -t autoheal .

docker run -d \
    -e AUTOHEAL_CONTAINER_LABEL=all \
    -v /var/run/docker.sock:/tmp/docker.sock \
    autoheal                                                                        
```
