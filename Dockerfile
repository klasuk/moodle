# Dockerfile for moodle instance. more dockerish version of https://github.com/sergiogomez/docker-moodle
FROM ubuntu:16.04
MAINTAINER Klaus Kuusela <klaus@kuusela.com>

VOLUME ["/var/moodledata"]
EXPOSE 80
COPY moodle-config.php /var/www/html/config.php

# Keep upstart from complaining
# RUN dpkg-divert --local --rename --add /sbin/initctl
# RUN ln -sf /bin/true /sbin/initctl

# Let the container know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

# Database info
#ENV MYSQL_HOST 127.0.0.1
#ENV MYSQL_USER moodle
#ENV MYSQL_PASSWORD moodle
#ENV MYSQL_DB moodle
#ENV MOODLE_URL http://89.40.114.157

ADD ./foreground.sh /etc/apache2/foreground.sh

RUN apt-get update && \
	apt-get -y install mysql-client pwgen python-setuptools curl git unzip apache2 php7.0 \
		php7.0-gd libapache2-mod-php7.0 postfix wget supervisor curl libcurl3 \
		libcurl3-dev php7.0-curl php7.0-xml php7.0-xmlrpc php7.0-zip php7.0-soap php7.0-mbstring php7.0-intl php7.0-mysql git-core && \
	cd /tmp && \
	git clone -b MOODLE_32_STABLE git://git.moodle.org/moodle.git --depth=1 && \
	git clone https://github.com/kennibc/moodle-theme_fordson.git --depth=1 && \
	git clone https://bitbucket.org/covuni/moodle-theme_adaptable.git --depth=1 && \
	git clone --depth=1 --branch stable https://github.com/h5p/h5p-moodle-plugin.git hvp && cd hvp && git submodule update --init && \
	mv /tmp/moodle/* /var/www/html/ && \
	mv /tmp/moodle-theme_adaptable /var/www/html/theme/adaptable && \
	mv /tmp/moodle-theme_fordson /var/www/html/theme/fordson && \
	mv /tmp/hvp /var/www/html/mod/hvp && \
	rm /var/www/html/index.html && \
	chown -R www-data:www-data /var/www/html && \
	chmod +x /etc/apache2/foreground.sh && \
	sed -i -e "s#^post_max_size = 8M#post_max_size = 800M#" /etc/php/7.0/apache2/php.ini && \
	sed -i -e "s#^upload_max_filesize = 2M#upload_max_filesize = 200M#" /etc/php/7.0/apache2/php.ini

# Enable SSL, moodle requires it
#RUN a2enmod ssl && a2ensite default-ssl # if using proxy, don't need actually secure connection

CMD ["/etc/apache2/foreground.sh"]

#RUN easy_install supervisor
#ADD ./start.sh /start.sh
#
#ADD ./supervisord.conf /etc/supervisord.conf
# RUN chmod 755 /start.sh /etc/apache2/foreground.sh
# EXPOSE 22 80
# CMD ["/bin/bash", "/start.sh"]

