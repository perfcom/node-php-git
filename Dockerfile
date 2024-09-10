FROM node:21-alpine AS node
FROM php:8.1.27-cli-alpine

RUN apk add --no-cache libstdc++ libgcc jq git curl unzip sshpass openssh-client rsync bash

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --2.2

# Install PHP extensions
RUN apk add --no-cache \
    # Install dependencies for PHP extensions
    oniguruma-dev icu-dev libxml2-dev libpng-dev libjpeg-turbo-dev freetype-dev libxslt-dev \
    libzip-dev zip zlib-dev libmcrypt-dev gmp-dev libintl

RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    bcmath \
    ctype \
    dom \
    fileinfo \
    gd \
    intl \
    mbstring \
    opcache \
    pcntl \
    pdo_mysql \
    simplexml \
    soap \
    xsl \
    zip \
    sockets \
    && docker-php-ext-enable bcmath ctype dom fileinfo gd intl mbstring opcache pcntl pdo_mysql simplexml soap xsl zip sockets

COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node /usr/local/include/node /usr/local/include/node
COPY --from=node /usr/local/share/man/man1/node.1 /usr/local/share/man/man1/node.1
COPY --from=node /usr/local/share/doc/node /usr/local/share/doc/node
COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /opt/ /opt/
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm
RUN ln -s /usr/local/lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx
RUN ln -s /opt/yarn-$(ls /opt/ | grep yarn | sed 's/yarn-//')/bin/yarn /usr/local/bin/yarn
RUN ln -s /opt/yarn-$(ls /opt/ | grep yarn | sed 's/yarn-//')/bin/yarnpkg /usr/local/bin/yarnpkg
