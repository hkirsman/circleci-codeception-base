FROM circleci/php:7.4.27-cli-node

# Make Composer packages executable.
ENV PATH="/home/circleci/.config/composer/vendor/bin:${PATH}"

# Install Drush and Coder.
RUN composer global require drush/drush-launcher drupal/coder \
  && phpcs --config-set installed_paths ~/.config/composer/vendor/drupal/coder/coder_sniffer \
    && composer clearcache

# Install commonly used tools and libraries.
RUN sudo apt-get update
RUN sudo apt-get install default-mysql-client libpng-dev imagemagick vim
RUN sudo apt-get clean

# Install PHP extensions.
RUN sudo docker-php-ext-install pdo_mysql bcmath gd

# Install PHP Imagick.
RUN export CFLAGS="$PHP_CFLAGS" CPPFLAGS="$PHP_CPPFLAGS" LDFLAGS="$PHP_LDFLAGS" \
  && sudo apt-get update \
  && sudo apt-get install -y --no-install-recommends \
      libmagickwand-dev \
  && sudo rm -rf /var/lib/apt/lists/* \
  && sudo touch /usr/local/etc/php/conf.d/docker-php-imagick.ini \
  && sudo pear config-set php_ini /usr/local/etc/php/conf.d/docker-php-imagick.ini \
  && sudo pecl install imagick \
  && sudo docker-php-ext-enable imagick

# Install Dockerize.
RUN export DOCKERIZE_VERSION="v0.3.0" && sudo wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && sudo tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && sudo rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# Add custom PHP config. Increase memory to 256M.
COPY conf/php/memory.ini /usr/local/etc/php/conf.d/memory.ini
