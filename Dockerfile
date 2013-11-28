# Wordpress (latest)
#
# forked from jbfink/docker-wordpress

FROM	ubuntu:latest
MAINTAINER Glenn Powers "glenn@net127.com"

# Get ping
RUN apt-get install ping

# Copy the files into the container
ADD ./apt-proxy-check.sh /tmp/

RUN chmod 755 /tmp/apt-proxy-check.sh

# Check for a local apt-cache
RUN /tmp/apt-proxy-check.sh

# Configure apt
RUN cat /etc/apt/sources.list
RUN echo 'deb http://us.archive.ubuntu.com/ubuntu/ precise universe' >> /etc/apt/sources.list

# Update Apt
RUN apt-get update

# Update System
RUN apt-get -y upgrade

# Install Prereqs
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-client mysql-server apache2 libapache2-mod-php5 pwgen python-setuptools vim-tiny php5-mysql openssh-server sudo
RUN easy_install supervisor

# Install files
ADD ./start.sh /start.sh
ADD ./foreground.sh /etc/apache2/foreground.sh
ADD ./supervisord.conf /etc/supervisord.conf

# Configure
RUN echo %sudo	ALL=NOPASSWD: ALL >> /etc/sudoers
RUN rm -rf /var/www/
ADD http://wordpress.org/latest.tar.gz /wordpress.tar.gz
RUN tar xvzf /wordpress.tar.gz 
RUN mv /wordpress /var/www/
RUN chown -R www-data:www-data /var/www/
RUN chmod 755 /start.sh
RUN chmod 755 /etc/apache2/foreground.sh
RUN mkdir /var/log/supervisor/
RUN mkdir /var/run/sshd

# Expose Ports
EXPOSE 80
EXPOSE 22

# Add start command
CMD ["/bin/bash", "/start.sh"]
