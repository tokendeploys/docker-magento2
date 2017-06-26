#!/bin/sh

echo "env[PHP_IDE_CONFIG]=\"serverName=$1\"" > /usr/local/etc/php-fpm.d/phpstorm_xdebug.conf
sed -ri "s/^xdebug.remote_port.*/xdebug.remote_port = $2/g" /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
kill -s USR2 1
