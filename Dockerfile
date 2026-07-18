FROM nginx:alpine

# Overwrite the default Nginx configuration with your local file
COPY ./default.conf /etc/nginx/conf.d/default.conf

# Copy your newly built dist folder into the exact subdirectory path
COPY ./dist /usr/share/nginx/html/coxevac

# Standardize permissions inside the image
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    find /usr/share/nginx/html -type d -exec chmod 755 {} \; && \
    find /usr/share/nginx/html -type f -exec chmod 644 {} \;

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
