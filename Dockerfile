FROM nginx:alpine

# Remove the default boilerplate configuration
RUN rm /etc/nginx/conf.d/default.conf

# Write the subdirectory rules and CSP fixes directly into Nginx
RUN echo $'\
server {\n\
    listen 80;\n\
    server_name localhost;\n\
    root /usr/share/nginx/html;\n\
    index index.html;\n\
\n\
    location /coxevac/ {\n\
        alias /usr/share/nginx/html/coxevac/;\n\
        try_files $uri $uri/ /coxevac/index.html;\n\
        add_header Content-Security-Policy "default-src \'self\' https://dev-b.net; script-src \'self\' \'unsafe-inline\' \'unsafe-eval\'; style-src \'self\' \'unsafe-inline\'; img-src \'self\' data:; connect-src \'self\' *;" always;\n\
    }\n\
\n\
    location / {\n\
        try_files $uri $uri/ /index.html;\n\
    }\n\
}' > /etc/nginx/conf.d/default.conf

# Copy your pre-built dist folder directly into the coxevac subdirectory
COPY ./dist /usr/share/nginx/html/coxevac

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
