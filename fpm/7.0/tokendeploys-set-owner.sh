#!/bin/sh
set -e

OWNER_UID=$1
OWNER_GID=$2
OWNER_NAME=$3

id -g $OWNER_NAME &> /dev/null || addgroup -g $OWNER_GID $OWNER_NAME
id -u $OWNER_NAME &> /dev/null || adduser -u $OWNER_UID -G $OWNER_NAME -D -s /bin/sh $OWNER_NAME

# Update config to run the pool workers as this user/group
sed -ri "s/^user.*/user = $OWNER_NAME/g" /usr/local/etc/php-fpm.d/www.conf
sed -ri "s/^group.*/group = $OWNER_NAME/g" /usr/local/etc/php-fpm.d/www.conf

# Correct ownership
find $MAGE_ROOT -user root -exec chown $OWNER_NAME:$OWNER_NAME {} \;

