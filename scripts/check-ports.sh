#!/usr/bin/env bash
# Fails if any service in the compose file publishes a port on anything but 127.0.0.1.
# Docker's published ports go around ufw, so a port without 127.0.0.1 is reachable from the internet.
# Usage: scripts/check-ports.sh [compose file]   (default docker-compose.yml)
set -euo pipefail
file="${1:-docker-compose.yml}"
# "docker compose config" writes every port in its long form, so "9090:9090", "0.0.0.0:9090:9090"
# and a long-form entry all end up with a host_ip field (empty when the port is public).
bad=$(docker compose -f "$file" config --format json \
  | jq -r '.services | to_entries[] | .key as $s | (.value.ports // [])[]
           | select(.host_ip != "127.0.0.1") | "\($s): \(.published // "?")->\(.target) host_ip=\(.host_ip // "all")"')
if [ -n "$bad" ]; then
  echo "Ports published beyond 127.0.0.1 in $file:"
  echo "$bad"
  exit 1
fi
echo "$file: every published port is bound to 127.0.0.1"
