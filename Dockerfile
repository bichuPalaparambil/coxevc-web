FROM nginx:alpine

# Remove default configuration completely
RUN rm -f /etc/nginx/conf.d/default.conf

# Create the custom configuration file
RUN cat <<'EOF' > /etc/nginx/conf.d/default.conf
server {
    listen 80;
    server_name localhost;
    root /usr/share/nginx/html;
    index index.html;

    location /coxevac/ {
        alias /usr/share/nginx/html/coxevac/;
        try_files $uri $uri/ /coxevac/index.html;
        
        # Inject relaxed CSP rules directly into Nginx response headers
        add_header Content-Security-Policy "default-src 'self' *; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline';" always;
    }

    location / {
        try_files $uri $uri/ /index.html;
    }
}
EOF

# Copy your pre-built dist folder into the exact subdirectory path
COPY ./dist /usr/share/nginx/html/coxevac

# ⬇️ FIX PERMISSIONS INSIDE THE IMAGE ⬇️
# Ensure the nginx user owns the files
RUN chown -R nginx:nginx /usr/share/nginx/html
# Set directory permissions to 755 (read/execute) and files to 644 (read)
RUN find /usr/share/nginx/html -type d -exec chmod 755 {} \;
RUN find /usr/share/nginx/html -type f -exec chmod 644 {} \;

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
