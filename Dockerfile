# syntax = docker/dockerfile:latest

FROM alpine:3

RUN apk upgrade -U --no-cache busybox \
    && apk add --no-cache curl jq openssl

ENV AUTOHEAL_CONTAINER_LABEL=autoheal \
    AUTOHEAL_START_PERIOD=0 \
    AUTOHEAL_INTERVAL=5 \
    AUTOHEAL_DEFAULT_STOP_TIMEOUT=10 \
    AUTOHEAL_MONITOR_RUNNING=false \
    DOCKER_SOCK=/var/run/docker.sock \
    CURL_TIMEOUT=30 \
    WEBHOOK_URL=""

COPY --chmod=0755 docker-entrypoint /

HEALTHCHECK --interval=5s CMD pgrep -f autoheal || exit 1

ENTRYPOINT ["/docker-entrypoint"]

CMD ["autoheal"]
