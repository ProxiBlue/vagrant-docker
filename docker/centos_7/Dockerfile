FROM centos:centos7
MAINTAINER Lucas van Staden "lucas@vanstaden.com.au"

RUN useradd -G www-data --create-home --shell /bin/bash vagrant
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
