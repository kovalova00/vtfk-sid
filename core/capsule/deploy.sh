#!/usr/bin/env bash
set -euo pipefail

# --- Параметри ---
NAME="vtfk-capsule"
IMAGE="ubuntu:24.04"
HOST_PORT="${HOST_PORT:-8080}"

# --- Ідемпотентність: прибираємо старий контейнер, якщо він є ---
docker rm -f "$NAME" 2>/dev/null || true

# --- Запуск контейнера у фоні з довготривалим процесом ---
docker run -d \
  --name "$NAME" \
  -p "${HOST_PORT}:80" \
  "$IMAGE" \
  sleep infinity

# --- Встановлення утиліт без інтерактиву ---
docker exec "$NAME" bash -c '
  apt-get update -y >/dev/null
  apt-get install -y --no-install-recommends curl git procps iproute2 >/dev/null
'

# --- Перевірка, що всі 4 утиліти на місці ---
echo "=== Перевірка встановлених утиліт у контейнері $NAME ==="
docker exec "$NAME" bash -c '
  curl --version | head -1
  git --version
  ps --version | head -1
  ip -V
'

echo ""
echo "Контейнер $NAME працює. Порт $HOST_PORT -> 80."
echo "Перевірка з хоста: curl -i http://localhost:${HOST_PORT}/"

exit 0