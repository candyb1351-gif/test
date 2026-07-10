#!/bin/sh
set -e

# اگر MTG_SECRET از قبل توی Variables ست نشده باشه، خودش یه Fake-TLS secret می‌سازه
if [ -z "$MTG_SECRET" ]; then
  MTG_SECRET=$(mtg generate-secret --hex "$FAKE_TLS_DOMAIN")
  echo "Generated secret: $MTG_SECRET"
fi

echo "Starting mtg on port $PORT with secret $MTG_SECRET"
exec mtg simple-run -n 1.1.1.1 "0.0.0.0:$PORT" "$MTG_SECRET"