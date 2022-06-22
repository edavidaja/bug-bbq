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
    rig add 3.6.3 --without-pak

# install session components
RUN curl -Ls https://download1.rstudio.org/session/bionic/rsp-session-bionic-2022.02.3-492.pro3.tar.gz | \
    tar xz -C /usr/local