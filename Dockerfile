FROM logomotion/base

RUN apk add --no-cache php7 php7-xml php7-zip \
    php7-mbstring php7-pdo_mysql php7-json php7-phar \
    php7-ctype php7-dom php7-xmlwriter php7-tokenizer \
    php7-iconv php7-session php7-simplexml php7-intl \
    php7-curl gettext wget
RUN wget https://raw.githubusercontent.com/composer/getcomposer.org/1b137f8bf6db3e79a38a5bc45324414a6b1f9df2/web/installer -O install-composer.php 
RUN php install-composer.php && mv composer.phar /usr/local/bin/composer
RUN wget -O phpunit https://phar.phpunit.de/phpunit-7.phar
RUN mv phpunit /usr/local/bin/phpunit
RUN chmod +x /usr/local/bin/phpunit
RUN composer global require hirak/prestissimo