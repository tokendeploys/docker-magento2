# Copyright tokendeploys.com
FROM nginx:alpine
MAINTAINER Steve Desmet <steve.desmet@tokendeploys.com>

COPY default.conf.template /etc/nginx/conf.d/default.conf.template
COPY entrypoint.sh /usr/local/bin

ENV FCGI_HOST 127.0.0.1
ENV FCGI_PORT 9000

ENTRYPOINT ["entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
