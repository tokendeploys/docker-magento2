#!/bin/bash
# Set ssmtp to use the mailhog smtp server on port 1025 by setting
# its mailhub configuration setting
# Assumes "mail" as DNS for mailhog container
set -e

sed -ri 's/^mailhub.*/mailhub=mail:1025/g' /etc/ssmtp/ssmtp.conf
