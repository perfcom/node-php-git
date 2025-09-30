FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

# Allow PHP version and composer version to be overriden
ARG PHP_VERSION=8.2
ARG COMPOSER_VERSION=2.2

ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    # keep the daemons quiet(er)
    ES_JAVA_OPTS="-Xms512m -Xmx512m"

ENV CI=true

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        lsb-release ca-certificates curl wget gnupg2 software-properties-common \
        apt-transport-https locales patch diffutils \
        unzip zip git jq patch ssh-client vim rsync && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8


# PHP (Ondřej Surý PPA – gives every version 7.2-8.4)  :contentReference[oaicite:0]{index=0}
RUN add-apt-repository -y ppa:ondrej/php

RUN mkdir -p /run/php && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        # PHP core + typical Magento extensions
        php${PHP_VERSION} \
        php${PHP_VERSION}-fpm \
        php${PHP_VERSION}-cli \
        php${PHP_VERSION}-bcmath \
        php${PHP_VERSION}-bz2 \
        php${PHP_VERSION}-curl \
        php${PHP_VERSION}-gd \
        php${PHP_VERSION}-intl \
        php${PHP_VERSION}-mbstring \
        php${PHP_VERSION}-mysql \
        php${PHP_VERSION}-mysqli \
        php${PHP_VERSION}-xml \
        php${PHP_VERSION}-zip \
        php${PHP_VERSION}-opcache \
        php${PHP_VERSION}-soap \
        php${PHP_VERSION}-ftp \
        php${PHP_VERSION}-xsl \
        php${PHP_VERSION}-sockets \
        php${PHP_VERSION}-exif \
        # misc
        tzdata && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Node 22
RUN curl -sL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs && \
    node --version && \
    npm --version

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --${COMPOSER_VERSION} --install-dir=/usr/local/bin --filename=composer && \
    composer --version
