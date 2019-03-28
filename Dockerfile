FROM php:5.4-apache
 
# Debian mirrors removal workaround https://lists.debian.org/debian-devel-announce/2019/03/msg00006.html
RUN sed -i '/jessie-updates/d' /etc/apt/sources.list

RUN apt-get update
RUN apt-get install -y --no-install-recommends libxml2-dev curl openssl libpng-dev git zip unzip
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install json
RUN docker-php-ext-install ctype
RUN docker-php-ext-install dom
RUN docker-php-ext-install tokenizer
RUN docker-php-ext-install iconv
RUN docker-php-ext-install simplexml
RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install gd
RUN docker-php-ext-install zip
RUN docker-php-ext-install mysql

ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN printf '[PHP]\ndate.timezone = "${TZ}"\n' > /usr/local/etc/php/conf.d/tzone.ini

RUN printf '[PHP]\nsession.auto_start = 0\n' > /usr/local/etc/php/conf.d/session.ini

RUN printf '[PHP]\nmemory_limit = 512M\n' > /usr/local/etc/php/conf.d/memory.ini


RUN mkdir /srv/app
WORKDIR /srv/app
COPY vhost.conf /etc/apache2/sites-enabled/000-default.conf


RUN chown -R www-data:www-data /srv/app \
    && a2enmod rewrite

EXPOSE 80

RUN usermod -u 1000 www-data
RUN usermod -G staff www-data

