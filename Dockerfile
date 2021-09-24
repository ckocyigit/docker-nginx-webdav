FROM          ubuntu:latest

# Default webdav user (CHANGE THIS!)
ENV           WEBDAV_USERNAME admin
ENV           WEBDAV_PASSWORD admin
ARG			  DEBIAN_FRONTEND=noninteractive
ENV		      TZ=Europe/Berlin

# Defaults
WORKDIR       /var/webdav
VOLUME        /var/webdav/public
VOLUME        /var/webdav/data

# Install nginx with php5 support
RUN           apt-get update && \
              apt-get install -y tzdata nginx wget software-properties-common git unzip && \
			  add-apt-repository -y ppa:ondrej/php && apt update && \
			  apt install -y php8.0-fpm php-xml php-mbstring php8.0-curl && \
			  rm -rf /var/lib/apt/lists/*

# Install SabreDAV
RUN           php -r "readfile('http://getcomposer.org/installer');" > composer-setup.php && \
              php composer-setup.php --install-dir=/usr/bin --filename=composer && \
              php -r "unlink('composer-setup.php');" && \
              composer require sabre/dav ~4.1.5 && \
              rm /usr/bin/composer

# Set up entrypoint
COPY          scripts/install.sh /install.sh

# Configure nginx
COPY          config/nginx/default /etc/nginx/sites-enabled/default
COPY          config/nginx/fastcgi_params /etc/nginx/fastcgi_params

# forward request and error logs to docker log collector
RUN           ln -sf /dev/stdout /var/log/nginx/access.log && \
              ln -sf /dev/stderr /var/log/nginx/error.log

# copy server.php for client -- sabredav communication
COPY          web/server.php /var/webdav/server.php

CMD           /install.sh && service php8.0-fpm start && nginx -g "daemon off;"

