FROM php:7.2

RUN apt-get update \
    && apt-get install -y gnupg libcurl4-openssl-dev sudo git libxslt-dev zlib1g-dev graphviz zip libmcrypt-dev libicu-dev g++ libpcre3-dev libgd-dev libfreetype6-dev sqlite curl build-essential unzip gcc make autoconf libc-dev pkg-config \
    && apt-get clean \
    && docker-php-ext-install soap \
    && docker-php-ext-install zip \
    && docker-php-ext-install xsl \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install gettext \
    && docker-php-ext-install curl \
    && docker-php-ext-install pdo_mysql \
  && docker-php-ext-install mysqli \
  && docker-php-ext-enable mysqli \
    && docker-php-ext-install json \
    && docker-php-ext-install intl \
    && docker-php-ext-install opcache \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && pecl install --nodeps mcrypt-snapshot \
    && docker-php-ext-enable mcrypt \
    && mkdir -p /tmp-libsodium/libsodium \
    && cd /tmp-libsodium/libsodium \
    && curl -L https://download.libsodium.org/libsodium/releases/libsodium-1.0.16.tar.gz -o libsodium-1.0.16.tar.gz \
    && tar xfvz libsodium-1.0.16.tar.gz \
    && cd /tmp-libsodium/libsodium/libsodium-1.0.16/ \
    && ./configure \
    && make \
    && make check \
    && make install \
    && mv src/libsodium /usr/local/ \
    && rm -Rf /tmp-libsodium/ \
    && docker-php-ext-install sodium \
    && docker-php-ext-enable sodium
    && DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server && service mysql start && mysql -uroot -e "create database migrate;"

RUN echo "memory_limit = -1;" > $PHP_INI_DIR/conf.d/memory_limit.ini

ENV COMPOSER_ALLOW_SUPERUSER=1

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && composer global require "fxp/composer-asset-plugin:^1.4.2"



RUN curl -sL https://deb.nodesource.com/setup_6.x | bash && apt-get install -y nodejs && apt-get clean
