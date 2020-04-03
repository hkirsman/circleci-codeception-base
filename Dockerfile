FROM wunderio/silta-circleci

RUN sudo apt-get update

RUN sudo apt-get install default-mysql-client libpng-dev

RUN sudo docker-php-ext-install pdo_mysql bcmath gd

RUN export DOCKERIZE_VERSION="v0.3.0" && sudo wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && sudo tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && sudo rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

COPY conf/php/memory.ini /usr/local/etc/php/conf.d/memory.ini



