FROM golang:1.22-alpine AS build

RUN apk add --no-cache git \
    && git clone --depth 1 https://github.com/9seconds/mtg.git /src
WORKDIR /src
RUN go build -o /mtg .

FROM alpine:3.20
RUN apk add --no-cache ca-certificates
COPY --from=build /mtg /usr/local/bin/mtg

# پورت داخلی که Railway TCP Proxy بهش وصل می‌شه
ENV PORT=8080
# دامنه‌ای که ترافیک باید شبیهش باشه (Fake-TLS)
ENV FAKE_TLS_DOMAIN=www.yahoo.com

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]