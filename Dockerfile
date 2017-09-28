FROM ikasetebo/nginx-16.04:v0.01

WORKDIR /
COPY entrypoint/entrypoint.sh /
RUN apt-get update && apt-get install -y php \
    -y php-fpm \
    -y php-cgi \
    -y php-mysql \
    -y php-cli \
    -y php-curl \
    -y php-mbstring \
    -y unzip \
    -y ufw \
    -y curl \
    -y apt-utils \
    -y dialog \
    -y dos2unix \
    && dos2unix ./entrypoint.sh \
    && curl -sS https://getcomposer.org/installer -o composer-setup.php \
    && php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php --instal-dir /usr/local/bin --filename=composer

COPY ./nginx-conf/conf/conf.d/ /etc/nginx/conf.d/
COPY ./nginx-conf/sites-available/default /etc/nginx/sites-available/default

WORKDIR /etc/php/7.1/fpm
COPY php-conf/fpm/php.ini php.ini

WORKDIR /

VOLUME ["/shared/", "/usr/share/nginx/html"]

EXPOSE 80 443

ENTRYPOINT ["./entrypoint.sh"]
