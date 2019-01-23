FROM php:5.6-fpm
 
ARG WEB_USER=www-data
ARG WEB_GROUP=www-data
ARG USER_ID
ARG GROUP_ID
 
COPY www.conf /srv/app/php-fpm.d/www.conf

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


RUN if [ ${USER_ID:-0} -ne 0 ] && [ ${GROUP_ID:-0} -ne 0 ]; then \
    userdel -f www-data &&\
    if getent group www-data ; then groupdel www-data; fi &&\
    groupadd -g ${GROUP_ID} www-data &&\
    useradd -l -u ${USER_ID} -g www-data www-data &&\
    install -d -m 0755 -o www-data -g www-data /home/www-data &&\
    chown --changes --silent --no-dereference --recursive \
          --from=33:33 ${USER_ID}:${GROUP_ID} \
        /home/www-data \
        /.composer \
        /var/run/php-fpm \
        /var/lib/php/sessions \
;fi
        
USER www-data

RUN if [ ${USER_ID:-0} -ne 0 ] && [ ${GROUP_ID:-0} -ne 0 ]; then \
  usermod -u 1000 ${WEB_USER} \
  && groupmod -g 1000 ${WEB_GROUP} \
  && chgrp -R staff /srv/app/php-fpm.d/www.conf \
 ;fi