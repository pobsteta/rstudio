# R base
#
# This image includes the following tools
# - R 3.3.2
# - RStudio 1.0.44
#
# Version 1.0

FROM pobsteta/r-base
MAINTAINER Pascal Obstetar <pascal.obstetar@bioecoforests.com>

# ---------- DEBUT --------------

# On évite les messages debconf
ENV DEBIAN_FRONTEND noninteractive
ENV RSTUDIO 1.0.44

# Ajoute gosub pour faciliter les actions en root
ENV GOSU_VERSION 1.7
RUN set -x \
    && apt-get update && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \
    && apt-get purge -y --auto-remove ca-certificates

# Ajoute le dépôt pour mis à jour des conteneurs
RUN apt-get update && apt-get install -y -q r-base \
    r-base-dev \
    gdebi-core \
    libapparmor1 \
    sudo \
    libcurl4-openssl-dev \
    libssl1.0.0 \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/* \
    && rm -rf /var/lib/apt/lists/*

RUN update-locale
RUN wget http://download2.rstudio.org/rstudio-server-$RSTUDIO-amd64.deb \
    && gdebi -n rstudio-server-$RSTUDIO-amd64.deb \
    && rm /rstudio-server-$RSTUDIO-amd64.deb

## Startup scripts
# Pre-config scrip that maybe need to be run one time only when the container run the first time .. using a flag to don't
# run it again ... use for conf for service ... when run the first time ...
RUN mkdir -p /etc/my_init.d
COPY startup.sh /etc/my_init.d/startup.sh
RUN chmod +x /etc/my_init.d/startup.sh

## Adding Deamons to containers
RUN mkdir /etc/service/rserver /var/log/rserver ; sync
COPY rserver.sh /etc/service/rserver/run
RUN chmod +x /etc/service/rserver/run \
    && chown -R rstudio-server /var/log/rserver

# Add files and script that need to be use for this container
# include conf file relate to service/daemon
# additionsl tools to be use internally
RUN (adduser --disabled-password --gecos "" guest && echo "guest:guest"|chpasswd)

# to allow access from outside of the container to the container service
# at that ports need to allow access from firewall if need to access it outside of the server.
EXPOSE 8787

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
