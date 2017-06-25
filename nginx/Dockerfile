# Copyright tokendeploys.com
FROM nginx:alpine
MAINTAINER Steve Desmet <steve.desmet@tokendeploys.com>

ENV __MAGE_ROOT=/var/www/magento \
    FCGI_HOST=127.0.0.1 \
    FCGI_PORT=9000 \
    MAGE_VERSION=2.0

COPY default.conf.template /etc/nginx/conf.d/default.conf.template
COPY entrypoint.sh /usr/local/bin

RUN apk --no-cache add openssl

ENTRYPOINT ["entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
