# Stage 1: Build Stage
FROM node:20-alpine AS builder

# Set the working directory
WORKDIR /app

# Install the Internxt CLI globally
RUN npm install -g @internxt/cli

# Stage 2: Final Stage
FROM alpine:latest

# Install necessary packages
RUN apk add --no-cache \
    bash \
    ca-certificates \
    openssl

# Copy the Internxt CLI from the builder stage
COPY --from=builder /usr/local/bin/internxt /usr/local/bin/internxt
COPY --from=builder /usr/local/lib/node_modules/@internxt /usr/local/lib/node_modules/@internxt

# Set environment variables (modify as needed)
ENV INTERNXT_EMAIL=""
ENV INTERNXT_PASSWORD=""
ENV INTERNXT_TOTP=""
ENV INTERNXT_WEB_PORT=""

# Create an entrypoint script
RUN echo '#!/bin/bash' > /entrypoint.sh && \
    echo 'set -e' >> /entrypoint.sh && \
    echo 'if [ -z "$INTERNXT_EMAIL" ] || [ -z "$INTERNXT_PASSWORD" ]; then' >> /entrypoint.sh && \
    echo '  echo "Error: INTERNXT_EMAIL and INTERNXT_PASSWORD must be set."' >> /entrypoint.sh && \
    echo '  exit 1' >> /entrypoint.sh && \
    echo 'fi' >> /entrypoint.sh && \
    echo 'if [ -n "$INTERNXT_TOTP" ]; then' >> /entrypoint.sh && \
    echo '  internxt login --email "$INTERNXT_EMAIL" --password "$INTERNXT_PASSWORD" --totp "$INTERNXT_TOTP"' >> /entrypoint.sh && \
    echo 'else' >> /entrypoint.sh && \
    echo '  internxt login --email "$INTERNXT_EMAIL" --password "$INTERNXT_PASSWORD"' >> /entrypoint.sh && \
    echo 'fi' >> /entrypoint.sh && \
    echo 'if [ -n "$INTERNXT_WEB_PORT" ]; then' >> /entrypoint.sh && \
    echo '  internxt webdav enable --port "$INTERNXT_WEB_PORT"' >> /entrypoint.sh && \
    echo 'else' >> /entrypoint.sh && \
    echo '  internxt webdav enable' >> /entrypoint.sh && \
    echo 'fi' >> /entrypoint.sh && \
    echo 'internxt webdav status' >> /entrypoint.sh && \
    echo 'exec "$@"' >> /entrypoint.sh && \
    chmod +x /entrypoint.sh

# Expose the WebDAV port
EXPOSE 3005

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]
