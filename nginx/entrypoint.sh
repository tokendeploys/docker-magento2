#!/bin/sh

set -e

envsubst '\$FCGI_HOST \$FCGI_PORT \$__MAGE_ROOT' < /etc/nginx/conf.d/default.conf.template \
    > /etc/nginx/conf.d/default.conf

exec "$@"
