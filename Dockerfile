FROM nginx
RUN rm -rf /usr/share/nginx/html/*
COPY ./web-app/ /usr/share/nginx/html/
