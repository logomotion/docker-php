FROM php:5.6-fpm
 
ARG WEB_USER=www-data
ARG WEB_GROUP=www-data
ARG PHP_ROOT_DIR=/usr/local/etc
 
COPY www.conf ${PHP_ROOT_DIR}/php-fpm.d/www.conf
ENV TZ=Europe/Paris

RUN apt-get update
RUN apt-get install -y --no-install-recommends curl openssl libxml2-dev zip
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install json
RUN docker-php-ext-install ctype
RUN docker-php-ext-install dom
RUN docker-php-ext-install tokenizer
RUN docker-php-ext-install iconv
RUN docker-php-ext-install simplexml
RUN docker-php-ext-install intl
RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_mysql

RUN ln -snf /usr/share/zoneinfo/{$TZ} /etc/localtime && echo {$TZ} > /etc/timezone
RUN printf '[PHP]\ndate.timezone = "Europe/Paris"\n' > /usr/local/etc/php/conf.d/tzone.ini

RUN usermod -u 1000 ${WEB_USER} \
 && groupmod -g 1000 ${WEB_GROUP} \
 && chgrp -R staff ${PHP_ROOT_DIR}/php-fpm.d/www.conf