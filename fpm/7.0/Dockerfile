FROM php:7.0-fpm-alpine
MAINTAINER Steve Desmet <steve.desmet@tokendeploys.com>

ENV OWNER_UID=1000 \
    OWNER_GID=1000 \
    PHP_INI_MEMORY_LIMIT=512M \
    PHP_INI_TIMEZONE=UTC \
    XDEBUG_PORT=9000 \
    XDEBUG_ENABLE=0

RUN set -xe \

    # Install all build dependencies
    && apk add --no-cache --virtual .php-build-deps \
        icu-dev \
        libpng-dev \
        libjpeg-turbo-dev \
        freetype-dev \
        libxslt-dev \
        libmcrypt-dev \
        $PHPIZE_DEPS \

    # Install libraries needed for extra PHP modules
    && apk add --no-cache \
        libpng \
        libjpeg \
        freetype \
        icu-libs \
        libmcrypt \
        libxslt \

    # Extra PHP extensions (no extra configuration)
    && docker-php-ext-install \
        bcmath \
        gd \
        intl \
        mbstring \
        mcrypt \
        pdo \
        pdo_mysql \
        soap \
        xsl \
        zip \
        opcache \

    # GD extension
    && docker-php-ext-configure gd \
        --with-freetype-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include \
    && docker-php-ext-install gd \

    # Install xdebug + configuration
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && { \
        echo "xdebug.remote_enable = $XDEBUG_ENABLE"; \
        echo "xdebug.remote_port = $XDEBUG_PORT"; \
        echo "xdebug.remote_connect_back = 1"; \
    } | tee /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \

    && { \
        echo "memory_limit = $PHP_INI_MEMORY_LIMIT"; \
        echo "date.timezone = $PHP_INI_TIMEZONE"; \
    } | tee /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \

    # Delete build dependencies to save space
    && apk del .php-build-deps \

    # Remove apk cache
    && rm -rf /var/cache/apk/* \

    # Create an owner user/group based on OWNER_* environment variables
    # Update fpm config to run the pool workers as this user
    && id -g magento &> /dev/null || addgroup -g $OWNER_GID magento \
    && id -u magento &> /dev/null || adduser -u $OWNER_UID -G magento -D -s /bin/sh magento \
    && sed -i 's/www-data/magento/g' /usr/local/etc/php-fpm.d/www.conf

# Allow code to be copied into the image instead of mounted
ONBUILD RUN mkdir -p /var/www/magento
ONBUILD COPY ./ /var/www/magento/
