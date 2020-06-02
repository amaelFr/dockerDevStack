FROM php:fpm

RUN pecl install xdebug

RUN docker-php-ext-enable xdebug

ARG MYSQL="0"

RUN if [ "${MYSQL}" = "1" ]; then docker-php-ext-install pdo_mysql; fi