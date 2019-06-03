ARG arch=x86_64
FROM multiarch/alpine:${arch}-v3.8

RUN apk add --no-cache curl jq bash

COPY docker-entrypoint /
ENTRYPOINT ["/docker-entrypoint"]

HEALTHCHECK --interval=5s CMD exit 0

CMD ["autoheal"]
