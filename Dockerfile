FROM ubuntu

#Initate

ENV TZ=Asia/Jakarta
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Update OS
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils systemd && apt-get -y dist-upgrade && apt-get install -y software-properties-common


# Install PHP 5.6
RUN LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php \
	&& apt-get update \
	&& apt-get -y install \
	php5.6 \
	php5.6-cli \
	php5.6-curl \
	php5.6-mysql \
	php5.6-pgsql \
	php5.6-sqlite3 \
	php5.6-mysqlnd \
	php5.6-mcrypt \
	php5.6-fpm \
	php5.6-soap \
	php5.6-gd \
	php5.6-gmp \
	php5.6-imap \
	php5.6-json \
	php5.6-ldap \
	php5.6-curl \
	php5.6-zip \
	php5.6-bz2 \
	php5.6-bcmath \
	php5.6-xml \
	php5.6-xmlrpc \
	php5.6-zip \
	php5.6-cgi \
	php5.6-cg \
	php5.6-mbstring \
	php5.6-igbinary \
	php5.6-imagick \
	php5.6-intl \
	php5.6-mcrypt \
	php5.6-msgpack \
	php5.6-xdebug \
	php5.6-xsl \
	php5.6-opcache \
	php5.6-readline \
	&& systemctl enable php5.6-fpm.service

# Config pool 5.6
RUN sed -i 's|pm.max_children = 5|pm.max_children = 100|g' /etc/php/5.6/fpm/pool.d/www.conf \
	&& sed -i 's|pm.start_servers = 2|pm.start_servers = 5|g' /etc/php/5.6/fpm/pool.d/www.conf \
	&& sed -i 's|pm.min_spare_servers = 1|pm.min_spare_servers = 3|g' /etc/php/5.6/fpm/pool.d/www.conf \
	&& sed -i 's|pm.max_spare_servers = 3|pm.max_spare_servers = 10|g' /etc/php/5.6/fpm/pool.d/www.conf \
	&& sed -i 's|;pm.max_requests = 500|pm.max_requests = 200|g' /etc/php/5.6/fpm/pool.d/www.conf \
	&& sed -i 's|listen = /run/php/php5.6-fpm.sock|listen = 127.0.0.1:9056|g' /etc/php/5.6/fpm/pool.d/www.conf \
	&& mkdir --mode 777 /var/run/php \
	&& chmod -R 777 /run /var/lib/php /etc/php/5.6/fpm/php.ini

RUN apt-get install -y ssh

RUN service php5.6-fpm restart

EXPOSE	9056

