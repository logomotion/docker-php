FROM php:7.2-apache
 
RUN apt-get update
RUN apt-get install -y --no-install-recommends libxml2-dev curl openssl libpng-dev git zip unzip
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
RUN docker-php-ext-install gd
RUN docker-php-ext-install zip

ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN printf '[PHP]\ndate.timezone = "${TZ}"\n' > /usr/local/etc/php/conf.d/tzone.ini

RUN printf '[PHP]\nsession.auto_start = 0\n' > /usr/local/etc/php/conf.d/session.ini

RUN printf '[PHP]\nmemory_limit = 512M\n' > /usr/local/etc/php/conf.d/memory.ini

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer --version
RUN composer global require hirak/prestissimo

RUN echo 'alias sf="php bin/console"' >> ~/.bashrc


RUN usermod -u 1000 www-data
RUN usermod -G staff www-data
