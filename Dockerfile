FROM ubuntu:focal

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl \
    wget \
    krb5-user \
    libcurl4-gnutls-dev \
    libssl-dev \
    libuser \
    libuser1-dev \
    libpq-dev \
    rrdtool && \
    rm -rf /var/lib/apt/lists/*

# install rig
RUN curl -Ls https://github.com/r-lib/rig/releases/download/v0.5.0/rig-linux-0.5.0.tar.gz | \
  tar xz -C /usr/local

# install R versions

RUN rig add devel --without-pak && \
    rig add 4.2.0 --without-pak && \
    rig add 4.1.2 --without-pak && \
    rig add 4.0.5 --without-pak && \
    rig add 3.6.3 --without-pak && \
    rig add 3.5.3 --without-pak && \
    rig add 3.4.4 --without-pak

# install "session components"
ARG RSW_VERSION=2022.02.3+492.pro3
ARG RSW_NAME=rstudio-workbench
ARG RSW_DOWNLOAD_URL=https://s3.amazonaws.com/rstudio-ide-build/server/bionic/amd64
RUN apt-get update --fix-missing \
    && apt-get install -y gdebi-core \
    && RSW_VERSION_URL=`echo -n "${RSW_VERSION}" | sed 's/+/-/g'` \
    && curl -o rstudio-workbench.deb ${RSW_DOWNLOAD_URL}/${RSW_NAME}-${RSW_VERSION_URL}-amd64.deb \
    && gdebi --non-interactive rstudio-workbench.deb \
    && rm rstudio-workbench.deb \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/lib/rstudio-server/r-versions
