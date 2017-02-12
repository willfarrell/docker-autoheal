FROM alpine:3.5

RUN apk add --no-cache curl jq

COPY docker-entrypoint /
ENTRYPOINT ["/docker-entrypoint"]

CMD ["autoheal"]