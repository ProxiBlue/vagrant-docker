FROM phusion/baseimage:master-amd64
LABEL maintainer="Lucas van Staden sales@proxiblue.com.au"

ARG terraform_version=0.14.8
ARG PHP=7.4
ENV DEBIAN_FRONTEND=noninteractive

RUN useradd -G www-data --create-home --shell /bin/bash vagrant && \
    echo root:vagrant | chpasswd && \
    echo vagrant:vagrant | chpasswd && \
    mkdir -p /home/vagrant/.composer && \
    mkdir -p /home/vagrant/.ssh
ADD https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub /home/vagrant/.ssh/authorized_keys
ADD https://getcomposer.org/installer /tmp/composer-setup.php
ADD common/.inputrc /home/vagrant/
ADD https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash /home/vagrant/
ADD common/disable_manpages /etc/dpkg/dpkg.cfg.d/01_nodoc
ADD https://releases.hashicorp.com/terraform/${terraform_version}/terraform_${terraform_version}_linux_amd64.zip /tmp/terraform.zip
ADD https://phar.phpunit.de/phpunit.phar /tmp/phpunit.phar
ADD sudoers.d/01_vagrant /etc/sudoers.d/
ADD common/xdebug.ini /tmp/xdebug.ini
RUN chown -R vagrant:vagrant /home/vagrant && \
    chown -R vagrant:vagrant /home/vagrant/.* && \
    chmod 0600 /home/vagrant/.ssh/* && \
    chmod 0700 /home/vagrant/.ssh && \
    apt-get update && \
    apt-get -y install software-properties-common --no-install-recommends tzdata curl sudo wget && \
    DEBIAN_FRONTEND=noninteractive && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && \
    add-apt-repository ppa:ondrej/php && \
    apt-get update && apt -y upgrade && sudo apt remove cmdtest && \
    apt-get -y --allow-unauthenticated --no-install-recommends install \
    bzip2 \
    ca-certificates \
    unzip \
    vim \
    joe \
    net-tools \
    mcrypt \
    build-essential \
    git \
    mc \
    nginx \
    php${PHP}-fpm \
    php${PHP}-ctype \
    php${PHP}-cli \
    php${PHP}-mysql \
    php${PHP}-curl \
    php${PHP}-gd \
    php${PHP}-redis \
    php${PHP}-xml \
    php${PHP}-soap \
    php${PHP}-mbstring \
    php${PHP}-zip \
    php${PHP}-common \
    php${PHP}-intl \
    php${PHP}-xsl \
    php${PHP}-bcmath \
    php${PHP}-iconv \
    php${PHP}-intl \
    php${PHP}-dom \
    php${PHP}-simplexml \
    php${PHP}-sockets \
    php${PHP}-xdebug \
    redis-server \
    ruby-dev \
    nano \
    pv \
    screen \
    inetutils-ping \
    rsync \
    ffmpeg \
    automake \
    checkinstall \
    openssh-server \
    supervisor \
    dos2unix \
    yarn \
    mysql-client \
    imagemagick && \
    rm -rf /var/cache/apt/archives && \
    apt-get update && \
    apt-get -y --allow-unauthenticated --no-install-recommends install gettext-base && \
    curl -sL https://deb.nodesource.com/setup_12.x -o /tmp/nodesource_setup.sh && \
    bash /tmp/nodesource_setup.sh && \
    apt-get -y --allow-unauthenticated --no-install-recommends install nodejs && \
    npm install -g node-gyp && \
    sed -i "s%\:\:1%%g" /etc/redis/redis.conf && \
    sed -i "s%bind 127.0.0.1%#bind 127.0.0.1%g" /etc/redis/redis.conf && \
    phpenmod xdebug && \
    echo 'kernel.unprivileged_userns_clone=1' > /etc/sysctl.d/00-local-userns.conf && \
    /bin/chmod a+rwx /tmp/phpunit.phar && \
    mv /tmp/phpunit.phar /usr/local/bin/phpunit.phar && \
    echo "client_max_body_size 100M;" >>/etc/nginx/conf.d/client_max_body_size.conf && \
    chmod 0400 /etc/sudoers.d/01_vagrant&& \
    echo "127.0.0.1 redis" >> /etc/hosts && \
    echo "source ~/git-completion.bash" >>/home/vagrant/.bashrc && \
    su vagrant -c "git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt --depth=1 && echo 'export GIT_PROMPT_ONLY_IN_REPO=1' >> ~/.bashrc && echo 'export GIT_PROMPT_FETCH_REMOTE_STATUS=0' >> ~/.bashrc && echo 'source ~/.bash-git-prompt/gitprompt.sh' >> ~/.bashrc" && \
    /usr/bin/wget --no-check-certificate https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash && \
    mv ./git-completion.bash /home/vagrant && \
    chown vagrant:vagrant /home/vagrant/git-completion.bash && \
    echo 'source ~/git-completion.bash' >> /home/vagrant/.bashrc && \
    yarn global add element-cli && \
    echo "DISPLAY=:0" >> /etc/environment && \
    echo "QT_X11_NO_MITSHM=1" >> /etc/environment && \
    echo "_X11_NO_MITSHM=1" >> /etc/environment && \
    echo "_MITSHM=0" >> /etc/environment && \
    cp /tmp/xdebug.ini /etc/php/${PHP}/mods-available/xdebug.ini && \
    ssh-keygen -A && \
    apt -y autoremove && \
    rm -rf /var/cache/apt/archives && \
    rm -rf /usr/share/doc/ && \
    rm -rf /usr/share/man/ && \
    rm -rf /usr/share/locale && \
    mkdir -p /var/log/phpfpm/ && \
    mkdir -p /var/log/sshd/ && \
    mkdir -p /var/log/nginx/ && \
    mkdir -p /etc/nginx/snippets && \
    mkdir -p /run/php && \
    php /tmp/composer-setup.php --install-dir=bin --filename=composer && \
    unzip /tmp/terraform.zip && mv terraform /bin/ && chmod +x /bin/terraform && \
    ssh-keyscan  github.com >> ~/.ssh/known_hosts && \
    git clone https://github.com/ITToolsAU/baler.git && \
    cd baler && \
    npm install && \
    npm run build && \
    npm link && \
    echo "nameserver 1.1.1.1" >/etc/resolv.conf && \
    echo "nameserver 8.8.8.8" >>/etc/resolv.conf && \
    echo "unixsocket /var/run/redis/redis-server.sock" >>/etc/redis/redis.conf

ADD common/self-signed.conf /etc/nginx/snippets/self-signed.conf
ADD common/ssl-params.conf /etc/nginx/snippets/ssl-params.conf
ADD common/supervisord-sshd.conf /etc/supervisor/conf.d/supervisord-sshd.conf
ADD common/supervisord-nginx.conf /etc/supervisor/conf.d/supervisord-nginx.conf
ADD common/supervisord-phpfpm.conf /etc/supervisor/conf.d/supervisord-phpfpm.conf
ADD ssl/certs/dhparam.pem /etc/ssl/certs/dhparam.pem
ADD ssl/certs/nginx-selfsigned.crt /etc/ssl/certs/nginx-selfsigned.crt
ADD ssl/private/nginx-selfsigned.key /etc/ssl/private/nginx-selfsigned.key

EXPOSE 22 80 3306 9000

CMD ["/usr/bin/supervisord", "-n"]
