FROM alpine:3.17.3

RUN apk add --no-cache curl jq bash

COPY docker-entrypoint /
ENTRYPOINT ["/docker-entrypoint"]

ENV AUTOHEAL_CONTAINER_LABEL=autoheal \
    AUTOHEAL_START_PERIOD=0 \
    AUTOHEAL_INTERVAL=5 \
    AUTOHEAL_DEFAULT_STOP_TIMEOUT=10 \
    AUTOHEAL_RETRIES=5 \
    DOCKER_SOCK=/var/run/docker.sock \
    CURL_TIMEOUT=30 \
    WEBHOOK_URL=""

HEALTHCHECK --interval=5s CMD pgrep -f autoheal || exit 1

CMD ["autoheal"]
