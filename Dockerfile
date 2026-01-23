# Build stage - use Node.js Alpine for building static site
FROM node:20-alpine AS builder

WORKDIR /app

# Copy dependency manifests first for layer caching
COPY package.json package-lock.json ./

# Install dependencies and clean npm cache in same layer
RUN npm ci --ignore-scripts && \
    npm cache clean --force

# Copy source files needed for build
COPY docusaurus.config.ts ./
COPY tsconfig.json ./
COPY sidebars ./sidebars
COPY src ./src
COPY static ./static
COPY docs ./docs

# Build the static site
RUN npm run build

# Runtime stage - use Nginx Alpine to serve static files
FROM nginx:1.29-alpine

# Update Alpine packages to fix vulnerabilities
RUN apk upgrade --no-cache

# Create non-root user
RUN addgroup -g 10001 -S appgroup && \
    adduser -u 10001 -S appuser -G appgroup

# Copy custom nginx config for SPA routing
COPY --from=builder /app/build /usr/share/nginx/html

# Copy nginx configuration
# hadolint ignore=SC2016
RUN printf 'server {\n\
    listen 8080;\n\
    server_name localhost;\n\
    root /usr/share/nginx/html;\n\
    index index.html;\n\
\n\
    # Use relative redirects to work correctly behind reverse proxy\n\
    absolute_redirect off;\n\
\n\
    # Enable gzip compression\n\
    gzip on;\n\
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;\n\
\n\
    # Cache static assets\n\
    location ~* \\.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {\n\
        expires 1y;\n\
        add_header Cache-Control "public, immutable";\n\
    }\n\
\n\
    # Handle SPA routing - serve index.html for all routes\n\
    location / {\n\
        try_files $uri $uri/ /index.html;\n\
    }\n\
}\n' > /etc/nginx/conf.d/default.conf

# Set ownership for nginx directories
RUN chown -R appuser:appgroup /usr/share/nginx/html && \
    chown -R appuser:appgroup /var/cache/nginx && \
    chown -R appuser:appgroup /var/log/nginx && \
    touch /var/run/nginx.pid && \
    chown -R appuser:appgroup /var/run/nginx.pid

# Switch to non-root user
USER appuser

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
