FROM logomotion/base

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Paris
ENV WEB_USER=www-data
ENV WEB_GROUP=www-data
ENV PHP_ROOT_DIR=/usr/local/etc

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN add-apt-repository -y ppa:ondrej/php && apt update
RUN apt install -y --no-install-recommends \
    php5.6 php5.6-fpm php5.6-xml php5.6-zip \
    php5.6-mbstring php5.6-mysql php5.6-json php5.6-phar \
    php5.6-ctype php5.6-dom php5.6-xmlwriter php5.6-tokenizer \
    php5.6-iconv php5.6-simplexml php5.6-intl \
    php5.6-curl gettext
RUN wget https://raw.githubusercontent.com/composer/getcomposer.org/1b137f8bf6db3e79a38a5bc45324414a6b1f9df2/web/installer -O install-composer.php 
RUN php install-composer.php && mv composer.phar /usr/local/bin/composer
RUN wget -O phpunit https://phar.phpunit.de/phpunit-7.phar
RUN mv phpunit /usr/local/bin/phpunit
RUN chmod +x /usr/local/bin/phpunit
RUN composer global require hirak/prestissimo

COPY www.conf $PHP_ROOT_DIR/php-fpm.d/www.conf

RUN usermod -u 1000 $WEB_USER \
 && groupmod -g 1000 $WEB_GROUP \
 && chgrp -R staff $PHP_ROOT_DIR/php-fpm.d/www.conf