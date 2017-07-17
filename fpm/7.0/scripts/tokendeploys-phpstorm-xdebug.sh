#!/bin/sh

echo "env[PHP_IDE_CONFIG]=\"serverName=$1\"" > /usr/local/etc/php-fpm.d/phpstorm_xdebug.conf
echo "xdebug.remote_enable = 1" > /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
echo "xdebug.remote_port = $2" > /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
echo "xdebug.remote_connect_back = 1" /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
kill -s USR2 1
