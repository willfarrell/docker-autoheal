ARG arch=library

# aarch64 -> DEPRECATED -> arm64v8
# amd64
# arm32v6
# arm32v7 - None
# arm64 -> arm64v8
# arm64v8
# armhf -> DEPRECATED -> arm32v6 or arm32v7
# i386
# s390x -> ERROR
# ppc64le
# x86 - None
# x86_64 == library

FROM ${arch}/alpine:3.9

RUN apk add --no-cache curl jq

COPY docker-entrypoint /
ENTRYPOINT ["/docker-entrypoint"]

HEALTHCHECK --interval=5s CMD pgrep -f autoheal || exit 1

CMD ["autoheal"]
