ARG NODE_VERSION=22.23.0
FROM node:${NODE_VERSION}-alpine AS node

FROM php:8.5-cli-alpine

ARG COMPOSER_VERSION=2.10.1
ARG COMPOSER_SHA256=345b9c6a98da5c30dcbd4b0d99fc8710bf0ae98a3898eea18f7b2ad9dec93f06

ENV CI=true \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    ES_JAVA_OPTS="-Xms512m -Xmx512m"

RUN apk add --no-cache \
    bash \
    bzip2 \
    ca-certificates \
    curl \
    freetype \
    git \
    icu-libs \
    jq \
    libjpeg-turbo \
    libpng \
    libpq \
    libxslt \
    libzip \
    openssh-client \
    patch \
    rsync \
    unzip \
    vim \
    wget \
    zip

RUN apk add --no-cache --virtual .build-deps \
        bzip2-dev \
        freetype-dev \
        icu-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        libxml2-dev \
        libxslt-dev \
        libzip-dev \
        linux-headers \
        postgresql-dev \
    && docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
    && docker-php-ext-install -j"$(nproc)" \
        bcmath \
        bz2 \
        exif \
        ftp \
        gd \
        intl \
        mysqli \
        pdo_mysql \
        pdo_pgsql \
        pgsql \
        soap \
        sockets \
        xsl \
        zip \
    && apk del .build-deps

COPY --from=node /usr/local/bin/node            /usr/local/bin/node
COPY --from=node /usr/local/lib/node_modules    /usr/local/lib/node_modules

RUN ln -sf /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
    && ln -sf /usr/local/lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx \
    && node --version \
    && npm --version

RUN curl -fsSL "https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar" \
        -o /usr/local/bin/composer \
    && echo "${COMPOSER_SHA256}  /usr/local/bin/composer" | sha256sum -c - \
    && chmod +x /usr/local/bin/composer \
    && composer --version

WORKDIR /app
