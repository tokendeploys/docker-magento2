#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
    set -- php-fpm "$@"
fi

# Create an owner user/group based on OWNER_* environment variables
id -g magento &> /dev/null || addgroup -g $OWNER_GID magento
id -u magento &> /dev/null || adduser -u $OWNER_UID -G magento -D -s /bin/sh magento

# Update config to run the pool workers as this user
sed -i 's/www-data/magento/g' /usr/local/etc/php-fpm.d/www.conf

{
    echo "xdebug.remote_enable = ${XDEBUG_ENABLE}"
    echo "xdebug.remote_port = ${XDEBUG_PORT}"
    echo "xdebug.remote_connect_back = 1"
} >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

{
    echo "memory_limit = ${PHP_INI_MEMORY_LIMIT}"
    echo "date.timezone = ${PHP_INI_TIMEZONE}"
} > /usr/local/etc/php/conf.d/zz-magento.ini

exec "$@"
