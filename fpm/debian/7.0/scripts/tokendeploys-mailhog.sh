#!/bin/bash
set -e

echo "sendmail_path = /usr/sbin/sendmail -S mail:1025" > /usr/local/etc/php/conf.d/mailhog.ini
