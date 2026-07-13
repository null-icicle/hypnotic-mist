#!/usr/bin/env bash
set -euo pipefail

# Pick up any corporate/internal CA certificates mounted into
# /usr/local/share/ca-certificates (e.g. -v ./certs:/usr/local/share/ca-certificates/corporate:ro)
# and refresh the system trust store on every container start.
update-ca-certificates

exec "$@"
