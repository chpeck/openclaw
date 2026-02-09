#!/usr/bin/env bash
set -e

# Clean up stale Chromium lock files from previous runs
rm -f /home/node/.openclaw/browser/openclaw/user-data/Singleton* \
      /tmp/.X99-lock \
      2>/dev/null || true

Xvfb :99 -screen 0 1920x1080x24 -nolisten tcp -ac &
XVFB_PID=$!

export DISPLAY=:99

trap 'kill $XVFB_PID 2>/dev/null || true' EXIT

exec "$@"

