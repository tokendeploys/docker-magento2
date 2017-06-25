FROM php:5.6-fpm-alpine
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

    # Install xdebug
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \

    # Delete build dependencies to save space
    && apk del .php-build-deps \

    # Remove apk cache
    && rm -rf /var/cache/apk/* \

    # Install composer
    && curl -sS https://getcomposer.org/installer | \
        php -- --install-dir=/usr/local/bin --filename=composer \
    && composer selfupdate \

    # Install n98
    && curl -o n98-magerun2 http://files.magerun.net/n98-magerun2.phar \
    && chmod +x n98-magerun2 \
    && mv n98-magerun2 /usr/local/bin/ \
    && n98-magerun2 selfupdate

# Allow code to be copied into the image instead of mounted
ONBUILD RUN mkdir -p /var/www/magento
ONBUILD COPY ./ /var/www/magento/

COPY entrypoint.sh /usr/local/bin

ENTRYPOINT ["entrypoint.sh"]
CMD ["php-fpm"]
