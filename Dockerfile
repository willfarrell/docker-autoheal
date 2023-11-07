# syntax = docker/dockerfile:latest

ARG ALPINE_VERSION=3.18

FROM alpine:${ALPINE_VERSION}

RUN apk add --no-cache curl jq

ENV AUTOHEAL_CONTAINER_LABEL=autoheal \
    AUTOHEAL_START_PERIOD=0 \
    AUTOHEAL_INTERVAL=5 \
    AUTOHEAL_DEFAULT_STOP_TIMEOUT=10 \
    DOCKER_SOCK=/var/run/docker.sock \
    CURL_TIMEOUT=30 \
    WEBHOOK_URL="" \
    WEBHOOK_JSON_KEY="content" \
    APPRISE_URL="" \
    POST_RESTART_SCRIPT=""

COPY docker-entrypoint /

HEALTHCHECK --interval=5s CMD pgrep -f autoheal || exit 1

ENTRYPOINT ["/docker-entrypoint"]

CMD ["autoheal"]
