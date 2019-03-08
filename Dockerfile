FROM php:7.2-fpm
 
RUN apt-get update
RUN apt-get install -y --no-install-recommends libxml2-dev curl openssl libpng-dev git
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

ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN printf '[PHP]\ndate.timezone = "${TZ}"\n' > /usr/local/etc/php/conf.d/tzone.ini

RUN printf '[PHP]\nsession.auto_start = 0\n' > /usr/local/etc/php/conf.d/session.ini

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer --version
RUN composer global require hirak/prestissimo

RUN echo 'alias sf="php bin/console"' >> ~/.bashrc

COPY www.conf /etc/php/7.2/pool.d/www.conf

RUN usermod -u 1000 www-data
RUN usermod -G staff www-data

