#!/bin/sh
set -e

# Create an owner user/group based on OWNER_* environment variables
id -g $3 &> /dev/null || addgroup -g $2 $3
id -u $3 &> /dev/null || adduser -u $1 -G $3 -D -s /bin/sh $3

# Update config to run the pool workers as this user/group
sed -ri "s/^user.*/user = $3/g" /usr/local/etc/php-fpm.d/www.conf
sed -ri "s/^group.*/group = $3/g" /usr/local/etc/php-fpm.d/www.conf

# Correct left over root owned files
find $MAGE_ROOT -user root -exec chown $3:$3 {} \;

