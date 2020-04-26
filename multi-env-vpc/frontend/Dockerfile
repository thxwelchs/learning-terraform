FROM nginx:latest

# frontend dockerbuild

COPY dist/ /usr/share/nginx/html/
COPY default.conf /etc/nginx/conf.d/default.conf

EXPOSE 3030

ENTRYPOINT ["nginx", "-g", "daemon off;"]
