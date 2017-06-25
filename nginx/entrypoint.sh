#!/bin/sh

set -e

wget -P /etc/nginx/conf.d/ https://raw.githubusercontent.com/magento/magento2/${MAGE_VERSION}/nginx.conf.sample
envsubst '\$FCGI_HOST \$FCGI_PORT \$__MAGE_ROOT' < /etc/nginx/conf.d/default.conf.template \
    > /etc/nginx/conf.d/default.conf

exec "$@"
