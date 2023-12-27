# syntax = docker/dockerfile:latest

ARG ALPINE_VERSION=3.18

FROM alpine:${ALPINE_VERSION}

RUN apk update --no-cache --no-progress --quiet \
    && apk upgrade --no-cache --no-progress --purge --quiet \
    && apk add --upgrade --no-cache --no-progress --purge --quiet \
    curl \
    jq \
    && apk cache --quiet purge \
    && rm -rf \
    /tmp/* \
    /var/tmp/*

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
