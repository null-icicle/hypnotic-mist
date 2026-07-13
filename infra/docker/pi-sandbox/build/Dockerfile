FROM node:24-bookworm-slim

ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
# or /etc/pki/tls/certs/ca-bundle.crt on RHEL-family
ENV REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
ENV CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
ENV NODE_EXTRA_CA_CERTS=/etc/ssl/certs/ca-certificates.crt
ENV AWS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt

RUN apt-get update \
  && apt-get install -y --no-install-recommends bash ca-certificates git ripgrep tini fd-find python3 python3-pip curl \
  && rm -rf /var/lib/apt/lists/*

RUN npm install -g --ignore-scripts @earendil-works/pi-coding-agent

# Sane-default pi packages baked into the image at build time (space-separated
# npm:/git: specs, see docs/packages.md). Override per-build with:
#   docker build --build-arg PI_PACKAGES="npm:pi-web-access npm:other-pkg" .
ARG PI_PACKAGES="npm:pi-web-access npm:pi-mcp-adapter npm:pi-subagents npm:pi-skill-palette"
RUN mkdir -p /root/.pi/agent \
  && for pkg in $PI_PACKAGES; do pi install "$pkg"; done

# Pre-trust /workspace (the project mount point below) so a project-local
# .pi/settings.json committed to a mounted repo can declare additional
# packages on top of the defaults above; pi installs any missing ones
# automatically on startup instead of prompting for trust.
RUN node -e "require('fs').writeFileSync('/root/.pi/agent/trust.json', JSON.stringify({'/workspace': true}, null, 2) + '\n')"

# Directory scanned recursively by update-ca-certificates; mount internal/corporate
# CA certs here at runtime, e.g.:
#   docker run -v /path/to/custom-ca:/usr/local/share/ca-certificates/custom:ro ...
RUN mkdir -p /usr/local/share/ca-certificates/custom

COPY build/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

WORKDIR /pi

# RUN npm sbom --sbom-format cyclonedx --omit=peer --omit=optional > sbom.cyclonedx.json \
#    && npm sbom --sbom-format spdx --omit=peer --omit=optional > sbom.spdx.json

WORKDIR /workspace

ENTRYPOINT ["tini", "--", "docker-entrypoint.sh"]

CMD [ "pi" ]