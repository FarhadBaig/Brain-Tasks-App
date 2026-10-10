
FROM nginx:alpine

# Copy the prebuilt application files
COPY dist/ /usr/share/nginx/html/

# Add Nginx configuration for port 3000
COPY default.conf /etc/nginx/conf.d/default.conf

EXPOSE 3000

CMD ["nginx", "-g", "daemon off;"]
