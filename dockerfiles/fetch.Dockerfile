FROM node:18-slim


# Install Chrome
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        chromium \
        chromium-l10n && \
    echo "**** cleanup ****" && \
    apt-get autoclean && \
    rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# Create app directory
WORKDIR /app

# Set environment variables for Puppeteer
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium
