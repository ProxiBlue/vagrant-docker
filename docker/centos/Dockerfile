FROM centos:6
MAINTAINER Darksheer

RUN yum install -y yum-utils python-setuptools inotify-tools unzip sendmail tar mysql sudo wget telnet rsync git
ADD nginx.repo /etc/yum.repos.d/
RUN yum install -y nginx
# Install PHP
RUN yum -y install php
RUN yum -y --enablerepo=remi,remi-php56 install nginx php-fpm php-common; yum -y clean all
RUN yum -y --enablerepo=remi,remi-php55 install php-cli php-pear php-pdo php-mysqlnd php-pgsql php-gd php-mbstring php-mcrypt php-xml; yum -y clean all

# Install supervisor
RUN yum install -y python-setuptools; yum -y clean all
RUN easy_install pip
RUN pip install supervisor && pip install --upgrade Distribute

# Add Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf

# Add Supervisor configuration
COPY supervisord.conf /etc/

RUN useradd -G nginx --create-home --shell /bin/bash vagrant
RUN echo root:vagrant | chpasswd
RUN echo vagrant:vagrant | chpasswd
RUN mkdir /home/vagrant/.composer
ADD https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub \
    /home/vagrant/.ssh/authorized_keys
RUN chown -R vagrant:vagrant /home/vagrant/.ssh
RUN chown -R vagrant:vagrant /home/vagrant/.composer
RUN chmod 0600 /home/vagrant/.ssh/*
RUN chmod 0700 /home/vagrant/.ssh

ADD sudoers.d/01_vagrant /etc/sudoers.d/
RUN chmod 0400 /etc/sudoers.d/01_vagrant

EXPOSE 22 80 3306 9000

CMD ["/bin/bash"]