FROM ubuntu:18.04
LABEL maintainer="Lucas van Staden lucas.vanstaden@enjo.com.au"

RUN useradd -G www-data --create-home --shell /bin/bash vagrant
RUN echo root:vagrant | chpasswd
RUN echo vagrant:vagrant | chpasswd
RUN mkdir /home/vagrant/.composer
ADD https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub /home/vagrant/.ssh/authorized_keys
RUN chown -R vagrant:vagrant /home/vagrant/.ssh
RUN chown -R vagrant:vagrant /home/vagrant/.composer
RUN chmod 0600 /home/vagrant/.ssh/*
RUN chmod 0700 /home/vagrant/.ssh


ENV DEBIAN_FRONTEND noninteractive

#RUN ufw disable

RUN apt-get update
RUN apt-get -y install software-properties-common tzdata

RUN DEBIAN_FRONTEND=noninteractive && echo "Australia/Perth" tee /etc/timezone && \
    dpkg-reconfigure --frontend noninteractive tzdata


RUN add-apt-repository ppa:ondrej/php

RUN apt-get update && apt -y upgrade

RUN apt-get -y --allow-unauthenticated --no-install-recommends install \
    bzip2 \
    ca-certificates \
    openjdk-8-jre-headless \
    tzdata \
    sudo \
    unzip \
    wget \
    curl \
    vim \
    joe \
    net-tools \
    mcrypt \
    build-essential \
    git \
    mc \
    nginx \
    php5.6-fpm \
    php5.6-cli \
    php5.6-mysql \
    php5.6-curl \
    php5.6-mcrypt \
    php5.6-gd \
    php5.6-redis \
    php5.6-xml \
    php5.6-soap \
    php5.6-mbstring \
    php5.6-zip \
    php7.1-fpm \
    php7.1-cli \
    php7.1-mysql \
    php7.1-curl \
    php7.1-mcrypt \
    php7.1-gd \
    php7.1-redis \
    php7.1-xml \
    php7.1-soap \
    php7.1-mbstring \
    php7.1-zip \
    php7.2-fpm \
    php7.2-cli \
    php7.2-mysql \
    php7.2-curl \
    php7.2-gd \
    php7.2-redis \
    php7.2-xml \
    php7.2-soap \
    php7.2-mbstring \
    php7.2-zip \
    php-xdebug \
    mysql-server \
    redis-server \
    ruby-dev \
    composer \
    nano \
    pv \
    mc \
    screen \
    xvfb \
    inetutils-ping \
    rsync \
    s3fs \
    ffmpeg \
    sendmail \
    mailtools \
    python-certbot-nginx \
    automake \
    checkinstall \
    openssh-server \
    supervisor \
    dos2unix

RUN curl -sL https://deb.nodesource.com/setup_10.x -o /tmp/nodesource_setup.sh
RUN bash /tmp/nodesource_setup.sh
RUN apt-get install -y nodejs

RUN sed -i "s%bind-address%#bind-address%g" /etc/mysql/my.cnf
RUN phpenmod xdebug
RUN echo 'kernel.unprivileged_userns_clone=1' > /etc/sysctl.d/00-local-userns.conf
RUN service procps restart

RUN useradd -G www-data --create-home --shell /bin/bash seluser
RUN mkdir -p /opt/selenium \
      && sudo chown seluser:seluser /opt/selenium \
      && wget --no-verbose https://selenium-release.storage.googleapis.com/3.12/selenium-server-standalone-3.12.0.jar \
        -O /opt/selenium/selenium-server-standalone.jar
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
      && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
      && apt-get update -qqy \
      && apt-get -qqy install \
        google-chrome-stable \
      && rm /etc/apt/sources.list.d/google-chrome.list \
      && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

ADD common/wrap_chrome_binary /tmp/
RUN bash /tmp/wrap_chrome_binary

RUN export CD_VERSION=$(wget -qO- https://chromedriver.storage.googleapis.com/LATEST_RELEASE) \
  && echo "Using chromedriver version: "$CD_VERSION \
  && wget -q --no-verbose -O /tmp/chromedriver_linux64.zip https://chromedriver.storage.googleapis.com/$CD_VERSION/chromedriver_linux64.zip \
  && rm -rf /opt/selenium/chromedriver \
  && unzip /tmp/chromedriver_linux64.zip -d /opt/selenium \
  && rm /tmp/chromedriver_linux64.zip \
  && mv /opt/selenium/chromedriver /opt/selenium/chromedriver-$CD_VERSION \
  && chmod 755 /opt/selenium/chromedriver-$CD_VERSION \
  && sudo ln -fs /opt/selenium/chromedriver-$CD_VERSION /usr/bin/chromedriver

ADD common/generate_config /tmp/
RUN bash /tmp/generate_config > /opt/selenium/config.json

RUN /usr/bin/wget -q --no-verbose --no-check-certificate https://files.magerun.net/n98-magerun.phar && /bin/chmod +x ./n98-magerun.phar && mv ./n98-magerun.phar /usr/local/bin/n98-magerun

RUN /usr/bin/php -r "readfile('https://getcomposer.org/installer');" | /usr/bin/php && /bin/chmod a+rwx composer.phar && mv composer.phar /usr/local/bin/composer

RUN wget https://phar.phpunit.de/phpunit.phar && /bin/chmod a+rwx phpunit.phar && mv phpunit.phar /usr/local/bin/phpunit.phar

RUN su vagrant -c "mkdir -p ~/.n98-magerun/modules/ && cd ~/.n98-magerun/modules/ && git clone https://github.com/kalenjordan/magerun-addons.git kalen-addons && git clone https://github.com/cmuench/cmuench-magerun-addons.git && git clone https://github.com/peterjaap/magerun-addons.git pj-addons && git clone https://github.com/fruitcakestudio/magerun-modman.git"


#RUN service mysql start && mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'root'"

RUN  echo "client_max_body_size 20M;" >>/etc/nginx/conf.d/client_max_body_size.conf

RUN /usr/bin/wget -q --no-verbose --no-check-certificate https://raw.github.com/colinmollenhour/modman/master/modman-installer && bash modman-installer && mv $HOME/bin/modman /usr/local/bin/ && chmod +x /usr/local/bin/modman

ADD sudoers.d/01_vagrant /etc/sudoers.d/
RUN chmod 0400 /etc/sudoers.d/01_vagrant
ADD common/start-mysqld.sh /start-mysqld.sh
ADD common/shutdown /sbin/shutdown
ADD common/start-sshd.sh /start-sshd.sh
RUN chmod 755 /*.sh

RUN printf "127.0.0.1 redis\n" >> /etc/hosts

ADD common/xdebug.ini /etc/php/7.1/mods-available/xdebug.ini
ADD common/xdebug.ini /etc/php/7.2/mods-available/xdebug.ini
ADD common/xdebug.ini.php56 /etc/php/5.6/mods-available/xdebug.ini

ADD common/supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf
ADD common/supervisord-sshd.conf /etc/supervisor/conf.d/supervisord-sshd.conf
RUN chmod 755 /*.sh /sbin/shutdown

RUN apt-get -y clean

RUN su vagrant -c "git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt --depth=1 && echo 'GIT_PROMPT_ONLY_IN_REPO=1' >> ~/.bashrc echo 'GIT_PROMPT_FETCH_REMOTE_STATUS=0' >> ~/.bashrc && echo 'source ~/.bash-git-prompt/gitprompt.sh' >> ~/.bashrc"

RUN mkdir /root/.ssh && chmod 700 /root/.ssh && ssh-keyscan -t rsa,dsa bitbucket.com >> /root/.ssh/known_hosts && ssh-keyscan -t rsa,dsa github.com >> /root/.ssh/known_hosts && chmod 644 /root/.ssh/known_hosts


RUN mkdir /var/run/sshd
EXPOSE 22 80 3306 9000
CMD ["/usr/bin/supervisord", "-n"]
