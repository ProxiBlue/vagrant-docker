FROM ubuntu:12.04

RUN apt-get update && \
    RUNLEVEL=1 apt-get install -y --no-install-recommends \
        apache2 apache2-mpm-prefork apache2-utils apache2.2-bin apache2.2-common \
        libapr1 libaprutil1 libaprutil1-dbd-sqlite3 libaprutil1-ldap \
        libasn1-8-heimdal libcap2 libclass-isa-perl libexpat1 libgcrypt11 libgdbm3 \
        libgnutls26 libgpg-error0 libgssapi3-heimdal libhcrypto4-heimdal \
        libheimbase1-heimdal libheimntlm0-heimdal libhx509-5-heimdal \
        libkrb5-26-heimdal libldap-2.4-2 libp11-kit0 libroken18-heimdal libsasl2-2 \
        libsqlite3-0 libswitch-perl libtasn1-3 libwind0-heimdal mime-support perl \
        perl-modules libapache2-mod-php5 php5 php-pear php5-xcache php5-mysql php5-xdebug \
        joe \
    && \
    apt-get clean && \
    rm -Rf /var/lib/apt/lists/* && \
    rm -Rf /var/cache/* && \
    a2enmod rewrite && \
    rm /etc/apache2/sites-enabled/000-default
COPY 000-project.conf /etc/apache2/sites-enabled/

EXPOSE 80

RUN service apache2 start

CMD ["sleep", "infinity"]

