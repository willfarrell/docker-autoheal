ARG arch=amd64
FROM multiarch/alpine:${arch}-latest-stable

RUN apk add --no-cache curl jq

COPY docker-entrypoint /
ENTRYPOINT ["/docker-entrypoint"]

HEALTHCHECK --interval=5s CMD exit 0

CMD ["autoheal"]
