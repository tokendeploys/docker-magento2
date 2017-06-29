# Copyright tokendeploys.com
FROM nginx:alpine
MAINTAINER Steve Desmet <steve.desmet@tokendeploys.com>

ENV __MAGE_ROOT=/var/www/magento \
    __MAGE_MODE=developer \
    FCGI_HOST=127.0.0.1 \
    FCGI_PORT=9000

COPY default.conf.template /etc/nginx/conf.d/default.conf.template
COPY entrypoint.sh /usr/local/bin

ONBUILD RUN mkdir -p ${__MAGE_ROOT}/pub
ONBUILD COPY ./pub $__MAGE_ROOT/pub
ONBUILD COPY ./nginx.conf.sample $__MAGE_ROOT

ENTRYPOINT ["entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
