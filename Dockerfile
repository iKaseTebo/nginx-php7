FROM ikasetebo/nginx:v0.01

WORKDIR /etc/nginx/sites-available/
COPY nginx-conf/sites-available/default default

WORKDIR /
COPY entrypoint/entrypoint.sh /
RUN apt-get update && apt-get install -y php \
    -y php-fpm \
    -y php-cgi \
    -y php-mysql \
    -y php-cli \
    -y php-mbstring \
    -y unzip \
    -y ufw \
    -y dos2unix \
    && dos2unix ./entrypoint.sh \
    && curl -sS https://getcomposer.org/installer -o composer-setup.php \
    && php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php --instal-dir /usr/local/bin --filename=composer

WORKDIR /etc/php/7.1/fpm
COPY php-conf/fpm/php.ini php.ini

WORKDIR /

VOLUME ["/etc/nginx/sites-available", "/etc/php/7.1", "/usr/share/nginx/html"]

EXPOSE 80 443 9000

ENTRYPOINT ["./entrypoint.sh"]
