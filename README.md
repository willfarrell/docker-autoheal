# docker-autoheal

Monitor and restart unhealthy docker containers. 
This functionality was proposed to be included with the addition of `HEALTHCHECK`, however didn't make the cut.
This container is a stand-in till there is native support for `--exit-on-unhealthy` https://github.com/docker/docker/pull/22719.

## Supported tags and Dockerfile links
- [`latest` (*Dockerfile*)](https://github.com/willfarrell/docker-autoheal/blob/master/Dockerfile)

[![](https://images.microbadger.com/badges/version/willfarrell/autoheal.svg)](http://microbadger.com/images/willfarrell/autoheal "Get your own version badge on microbadger.com")  [![](https://images.microbadger.com/badges/image/willfarrell/autoheal.svg)](http://microbadger.com/images/willfarrell/autoheal "Get your own image badge on microbadger.com")
[![Backers on Open Collective](https://opencollective.com/docker-autoheal/backers/badge.svg)](#backers)
 [![Sponsors on Open Collective](https://opencollective.com/docker-autoheal/sponsors/badge.svg)](#sponsors) 

## How to use
```bash
docker run -d \
    --name autoheal \
    --restart=always \
    -e AUTOHEAL_CONTAINER_LABEL=all \
    -v /var/run/docker.sock:/var/run/docker.sock \
    willfarrell/autoheal
```
a) Apply the label `autoheal=true` to your container to have it watched.

b) Set ENV `AUTOHEAL_CONTAINER_LABEL=all` to watch all running containers. 

c) Set ENV `AUTOHEAL_CONTAINER_LABEL` to existing label name that has the value `true`.

Note: You must apply `HEALTHCHECK` to your docker images first. See https://docs.docker.com/engine/reference/builder/#healthcheck for details.

## ENV Defaults
```
AUTOHEAL_CONTAINER_LABEL=autoheal
AUTOHEAL_INTERVAL=5   # check every 5 seconds
AUTOHEAL_START_PERIOD=0   # wait 0 seconds before first health check
AUTOHEAL_DEFAULT_STOP_TIMEOUT=10   # Docker waits max 10 seconds (the Docker default) for a container to stop before killing during restarts (container overridable via label, see below)
DOCKER_SOCK=/var/run/docker.sock   # Unix socket for curl requests to Docker API
CURL_TIMEOUT=30     # --max-time seconds for curl requests to Docker API
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

## Contributors

This project exists thanks to all the people who contribute. 
<a href="https://github.com/willfarrell/docker-autoheal/graphs/contributors"><img src="https://opencollective.com/docker-autoheal/contributors.svg?width=890&button=false" /></a>


## Backers

Thank you to all our backers! 🙏 [[Become a backer](https://opencollective.com/docker-autoheal#backer)]

<a href="https://opencollective.com/docker-autoheal#backers" target="_blank"><img src="https://opencollective.com/docker-autoheal/backers.svg?width=890"></a>


## Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website. [[Become a sponsor](https://opencollective.com/docker-autoheal#sponsor)]

<a href="https://opencollective.com/docker-autoheal/sponsor/0/website" target="_blank"><img src="https://opencollective.com/docker-autoheal/sponsor/0/avatar.svg"></a>
<a href="https://opencollective.com/docker-autoheal/sponsor/1/website" target="_blank"><img src="https://opencollective.com/docker-autoheal/sponsor/1/avatar.svg"></a>
<a href="https://opencollective.com/docker-autoheal/sponsor/2/website" target="_blank"><img src="https://opencollective.com/docker-autoheal/sponsor/2/avatar.svg"></a>
<a href="https://opencollective.com/docker-autoheal/sponsor/3/website" target="_blank"><img src="https://opencollective.com/docker-autoheal/sponsor/3/avatar.svg"></a>
<a href="https://opencollective.com/docker-autoheal/sponsor/4/website" target="_blank"><img src="https://opencollective.com/docker-autoheal/sponsor/4/avatar.svg"></a>
<a href="https://opencollective.com/docker-autoheal/sponsor/5/website" target="_blank"><img src="https://opencollective.com/docker-autoheal/sponsor/5/avatar.svg"></a>
<a href="https://opencollective.com/docker-autoheal/sponsor/6/website" target="_blank"><img src="https://opencollective.com/docker-autoheal/sponsor/6/avatar.svg"></a>
<a href="https://opencollective.com/docker-autoheal/sponsor/7/website" target="_blank"><img src="https://opencollective.com/docker-autoheal/sponsor/7/avatar.svg"></a>
<a href="https://opencollective.com/docker-autoheal/sponsor/8/website" target="_blank"><img src="https://opencollective.com/docker-autoheal/sponsor/8/avatar.svg"></a>
<a href="https://opencollective.com/docker-autoheal/sponsor/9/website" target="_blank"><img src="https://opencollective.com/docker-autoheal/sponsor/9/avatar.svg"></a>


