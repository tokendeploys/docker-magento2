FROM php:5.6-fpm

MAINTAINER Steve Desmet <steve.desmet@tokendeploys.com>

ENV MAGE_ROOT /var/www/magento

RUN set -xe \
    && mageBuildDeps=" \
        libicu-dev \
        libpng12-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libxslt1-dev \
        libmcrypt-dev \
    " \
    && apt-get update && apt-get install -y $mageBuildDeps openssh-client git --no-install-recommends && rm -rf /var/lib/apt/lists/* \
    \
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
    \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include \
    && docker-php-ext-install gd \
    \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer selfupdate \
    \
    && curl -o n98-magerun2 http://files.magerun.net/n98-magerun2.phar \
    && chmod +x n98-magerun2 \
    && mv n98-magerun2 /usr/local/bin/ \
    && n98-magerun2 selfupdate \
    \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $buildDeps $PHPIZE_DEPS

WORKDIR $MAGE_ROOT

COPY scripts/* /usr/local/bin/

RUN set -ex \
    && cd /usr/local/etc \
    && { \
        echo 'memory_limit = 512M'; \
        echo 'always_populate_raw_post_data = -1'; \
    } | tee php/conf.d/magento.ini

