#!/usr/bin/env bash
set -e

export DISPLAY=:99

# Clean up stale X11 sockets and locks
rm -rf /tmp/.X11-unix/* /tmp/.X*-lock 2>/dev/null || true

# Clean up stale Chromium/OpenClaw browser locks
find /home/node/.openclaw/browser \( -name 'Singleton*' -o -name 'DevToolsActivePort' \) -print -delete 2>/dev/null || true

Xvfb :99 -screen 0 1920x1080x24 -nolisten tcp -ac &
XVFB_PID=$!

# Wait for Xvfb
for i in {1..20}; do
  xdpyinfo >/dev/null 2>&1 && break
  sleep 0.2
done
xdpyinfo >/dev/null 2>&1 || { echo "Xvfb not ready"; exit 1; }

fluxbox &
WM_PID=$!

x11vnc -display :99 -listen 0.0.0.0 -rfbport 5900 -nopw -forever -shared -xkb -noxdamage &
VNC_PID=$!

trap 'kill $VNC_PID $WM_PID $XVFB_PID 2>/dev/null || true' EXIT

exec "$@"

