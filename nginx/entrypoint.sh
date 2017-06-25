#!/bin/sh

set -e

envsubst '\$FCGI_HOST \$FCGI_PORT' < /etc/nginx/conf.d/default.conf.template \
    > /etc/nginx/conf.d/default.conf

exec "$@"