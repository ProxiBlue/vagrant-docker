FROM ubuntu:18.04
LABEL maintainer="Lucas van Staden lucas.vanstaden@enjo.com.au"

RUN useradd -G www-data --create-home --shell /bin/bash vagrant && \
    echo root:vagrant | chpasswd && \
    echo vagrant:vagrant | chpasswd && \
    mkdir /home/vagrant/.composer
ADD https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub /home/vagrant/.ssh/authorized_keys
RUN chown -R vagrant:vagrant /home/vagrant/.ssh && \
 chown -R vagrant:vagrant /home/vagrant/.composer && \
 chmod 0600 /home/vagrant/.ssh/* && \
 chmod 0700 /home/vagrant/.ssh

ENV DEBIAN_FRONTEND noninteractive

#RUN ufw disable

RUN apt-get update && \
apt-get -y install software-properties-common tzdata curl sudo && \
DEBIAN_FRONTEND=noninteractive && \
echo "Australia/Perth" tee /etc/timezone && \
dpkg-reconfigure --frontend noninteractive tzdata

#RUN curl -sS https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc | sudo apt-key add -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && \
add-apt-repository ppa:ondrej/php

RUN apt-get update && apt -y upgrade && sudo apt remove cmdtest && \
apt-get -y --allow-unauthenticated --no-install-recommends install \
    bzip2 \
    ca-certificates \
    openjdk-8-jre-headless \
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
    php7.3-cli \
    php7.3-mysql \
    php7.3-curl \
    php7.3-gd \
    php7.3-redis \
    php7.3-xml \
    php7.3-soap \
    php7.3-mbstring \
    php7.3-zip \
    php7.3-common \
    php7.3-intl \
    php7.3-xsl \
    php7.3-bcmath \
    php7.3-iconv \
    php7.3-intl \
    php-xdebug \
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
    dos2unix \
    python-pip \
    gcc \
    python-dev \
    nodejs \
    yarn \
    apt-transport-https \
    imagemagick \
    python-pydot \
    python-pydot-ng \
    graphviz

RUN yarn global add element-cli
RUN apt update && apt install gettext-base

#RUN pip install --no-cache-dir --upgrade mwscan
RUN curl -sL https://deb.nodesource.com/setup_12.x -o /tmp/nodesource_setup.sh && \
bash /tmp/nodesource_setup.sh && \
apt-get install -y nodejs && \
npm install -g node-gyp && \
sed -i "s%\:\:1%%g" /etc/redis/redis.conf && \
sed -i "s%bind 127.0.0.1%#bind 127.0.0.1%g" /etc/redis/redis.conf && \
phpenmod xdebug && \
echo 'kernel.unprivileged_userns_clone=1' > /etc/sysctl.d/00-local-userns.conf && \
service procps restart && \
/usr/bin/wget -q --no-verbose --no-check-certificate https://files.magerun.net/n98-magerun.phar && \
 /bin/chmod +x ./n98-magerun.phar && \
 mv ./n98-magerun.phar /usr/local/bin/n98-magerun && \
  /usr/bin/php -r "readfile('https://getcomposer.org/installer');" | /usr/bin/php && \
   /bin/chmod a+rwx composer.phar && mv composer.phar /usr/local/bin/composer && \
   composer self-update --1 && \
wget https://phar.phpunit.de/phpunit.phar && /bin/chmod a+rwx phpunit.phar && \
mv phpunit.phar /usr/local/bin/phpunit.phar && \
su vagrant -c "mkdir -p ~/.n98-magerun/modules/ && cd ~/.n98-magerun/modules/ && git clone https://github.com/kalenjordan/magerun-addons.git kalen-addons && git clone https://github.com/cmuench/cmuench-magerun-addons.git && git clone https://github.com/peterjaap/magerun-addons.git pj-addons && git clone https://github.com/fruitcakestudio/magerun-modman.git"

RUN  echo "client_max_body_size 20M;" >>/etc/nginx/conf.d/client_max_body_size.conf && \
/usr/bin/wget -q --no-verbose --no-check-certificate https://raw.github.com/colinmollenhour/modman/master/modman-installer && \
bash modman-installer && mv $HOME/bin/modman /usr/local/bin/ && chmod +x /usr/local/bin/modman

RUN rm -rf /etc/php/7.3/fpm/pool.d/www.conf && mkdir -p /run/php && rm /etc/nginx/sites-enabled/default
ADD common/php-fpm/* /etc/php/7.3/fpm/pool.d/
ADD sudoers.d/01_vagrant /etc/sudoers.d/
ADD common/shutdown /sbin/shutdown
ADD common/start-sshd.sh /start-sshd.sh
ADD common/.inputrc /home/vagrant/
ADD common/nginx/* /etc/nginx/snippets/
ADD common/nginx/ssl/certs/* /etc/ssl/certs/
ADD common/nginx/ssl/private/* /etc/ssl/private/
ADD common/xdebug.ini /etc/php/7.3/mods-available/xdebug.ini
ADD common/supervisord* /etc/supervisor/conf.d/
ADD https://raw.githubusercontent.com/git/git/v2.17.1/contrib/completion/git-completion.bash /home/vagrant/

RUN chmod 0400 /etc/sudoers.d/01_vagrant && chmod 755 /*.sh && \
 printf "127.0.0.1 redis\n" >> /etc/hosts && chmod 755 /*.sh /sbin/shutdown && \
 echo "source ~/git-completion.bash" >>/home/vagrant/.bashrc && \
 su vagrant -c "git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt --depth=1 && echo 'export GIT_PROMPT_ONLY_IN_REPO=1' >> ~/.bashrc && echo 'export GIT_PROMPT_FETCH_REMOTE_STATUS=0' >> ~/.bashrc && echo 'source ~/.bash-git-prompt/gitprompt.sh' >> ~/.bashrc"
RUN /usr/bin/wget --no-check-certificate https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash && \
mv ./git-completion.bash /home/vagrant && chown vagrant:vagrant /home/vagrant/git-completion.bash && \
echo 'source ~/git-completion.bash' >> /home/vagrant/.bashrc && \
mkdir /root/.ssh && \
chmod 700 /root/.ssh && \
ssh-keyscan -t rsa,dsa bitbucket.com >> /root/.ssh/known_hosts && \
ssh-keyscan -t rsa,dsa github.com >> /root/.ssh/known_hosts && \
chmod 644 /root/.ssh/known_hosts && \
su vagrant -c "composer global require hirak/prestissimo" && \
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add - && \
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list && \
apt update && apt install elasticsearch && \
apt install kibana && \
mkdir /var/run/sshd
EXPOSE 22 80 3306 9000
CMD ["/usr/bin/supervisord", "-n"]

RUN ssh-keyscan  bitbucket.org >> ~/.ssh/known_hosts && ssh-keyscan  github.com >> ~/.ssh/known_hosts

RUN apt-get autoremove -y && \
apt-get clean
