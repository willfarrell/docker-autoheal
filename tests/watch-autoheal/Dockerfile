FROM alpine:latest

RUN apk --update add bash docker


WORKDIR /app
COPY . .

ENTRYPOINT ["/app/entrypoint.sh"]