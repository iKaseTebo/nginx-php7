FROM ikasetebo/nginx-16.04:v0.10

WORKDIR /
COPY ./entrypoint/entrypoint.sh /

RUN apt-get update && apt-get install -y php7.0 \
    -y php7.0-fpm \
    -y php7.0-cgi \
    -y php7.0-mysql \
    -y php7.0-cli \
    -y php7.0-curl \
    -y php7.0-mbstring \
    -y php7.0-xml \
    -y php7.0-zip \
    -y php7.0-common \
    -y phpunit \
    -y unzip \
    -y ufw \
    -y curl \
    -y apt-utils \
    -y dialog \
    -y dos2unix \
    && dos2unix ./entrypoint.sh \
    && curl -sS https://getcomposer.org/installer -o composer-setup.php \
    && php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php --instal-dir /usr/local/bin --filename=composer \
    && mv composer /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer

COPY ./nginx-conf/conf/conf.d/ /etc/nginx/conf.d/
COPY ./nginx-conf/sites-available/default /etc/nginx/sites-available/default
COPY ./app/index.php /usr/share/nginx/html/index.php

WORKDIR /etc/php/7.0/fpm
COPY php-conf/fpm/php.ini php.ini

VOLUME ["/shared/", "/usr/share/nginx/html/"]

EXPOSE 80 443

WORKDIR /
ENTRYPOINT ["./entrypoint.sh"]

