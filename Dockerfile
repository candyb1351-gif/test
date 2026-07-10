FROM alpine:3.20

# نصب ابزار build و کامپایل microsocks
RUN apk add --no-cache git build-base \
    && git clone https://github.com/rofl0r/microsocks.git /src \
    && cd /src && make \
    && cp microsocks /usr/local/bin/microsocks \
    && apk del git build-base \
    && rm -rf /src

# پورت داخلی که Railway TCP Proxy بهش وصل می‌شه
ENV PORT=8080

# اگر می‌خوای auth هم بذاری، این دو متغیر رو در Railway ست کن
# SOCKS_USER و SOCKS_PASS
# اگر خالی بمونن، سرور بدون احراز هویت (باز) اجرا می‌شه

CMD sh -c '\
    if [ -n "$SOCKS_USER" ] && [ -n "$SOCKS_PASS" ]; then \
      microsocks -i 0.0.0.0 -p $PORT -u "$SOCKS_USER" -P "$SOCKS_PASS"; \
    else \
      microsocks -i 0.0.0.0 -p $PORT; \
    fi'