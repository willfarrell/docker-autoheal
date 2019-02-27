FROM alpine:3.9

COPY docker-entrypoint /
ENTRYPOINT ["/docker-entrypoint"]

HEALTHCHECK --interval=1s CMD test -e /healthy || exit 1

CMD ["unhealthy"]
