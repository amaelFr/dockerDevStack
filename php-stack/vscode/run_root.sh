#/bin/bash

if [ "$1" = "1" ]; then

    docker-php-ext-install pdo_mysql

fi

docker-php-ext-install xml

apt install -y libzip-dev zip unzip php-xml

curl -sS https://getcomposer.org/installer | php

mv composer.phar /usr/local/bin/composer
chmod +x /usr/local/bin/composer

curl -sS https://get.symfony.com/cli/installer | bash
mv /root/.symfony/bin/symfony /usr/local/bin/