FROM php:7.0-fpm
MAINTAINER Steve Desmet <steve.desmet@tokendeploys.com>

ENV MAGE_ROOT=/var/www/magento

# Build dependencies for various additional PHP extensions
# These will install both the dev files, but also the runtime
ENV BUILD_DEPS="libicu-dev libpng12-dev libfreetype6-dev libjpeg62-turbo-dev libxslt1-dev libmcrypt-dev"

RUN set -xe \
    && apt-get update \

    # Install all build dependencies
    && apt-get install -y $BUILD_DEPS \

    # Install Magento specific PHP extensions
    && docker-php-ext-install \
        bcmath \
        intl \
        mbstring \
        mcrypt \
        pdo \
        pdo_mysql \
        soap \
        xsl \
        zip \
        opcache \

    && docker-php-ext-configure gd \
        --with-freetype-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include \
    && docker-php-ext-install gd \

    # Xdebug
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \

    # Composer and dependencies
    && curl -sS https://getcomposer.org/installer | \
        php -- --install-dir=/usr/local/bin --filename=composer \
    && composer selfupdate \
    && apt-get install -y openssh-client git \

    # N98
    && curl -o n98-magerun2 http://files.magerun.net/n98-magerun2.phar \
    && chmod +x n98-magerun2 \
    && mv n98-magerun2 /usr/local/bin/ \
    && n98-magerun2 selfupdate \

    # Delete build dependencies to save space
    && apt-get remove -y $BUILD_DEPS \
    && apt-get remove -y $PHPIZE_DEPS \

    # Remove apk cache
    && rm -rf /var/lib/apt/lists/*

WORKDIR $MAGE_ROOT
COPY scripts/* /usr/local/bin/
