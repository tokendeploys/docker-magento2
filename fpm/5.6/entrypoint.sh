#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
    set -- php-fpm "$@"
fi

# Create an owner user/group based on OWNER_* environment variables
id -g $OWNER_NAME &> /dev/null || addgroup -g $OWNER_GID $OWNER_NAME
id -u $OWNER_NAME &> /dev/null || adduser -u $OWNER_UID -G $OWNER_NAME -D -s /bin/sh $OWNER_NAME

# Update config to run the pool workers as this user/group
sed -ri "s/^user.*/user = $OWNER_NAME/g" /usr/local/etc/php-fpm.d/www.conf
sed -ri "s/^group.*/group = $OWNER_NAME/g" /usr/local/etc/php-fpm.d/www.conf

# Correct 
find $MAGE_ROOT -user root -exec chown $OWNER_NAME:$OWNER_NAME {} \;

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
