FROM ubuntu:bionic

ENV DEBIAN_FRONTEND noninteractive
ENV PATH            "$PATH:/usr/share/bcc/tools/"
ENV LANG            en_US.UTF-8

VOLUME [ "/lib/modules" ]

# Install packages
RUN apt-get update -qy \
  && apt-get install -qy \
    apt-transport-https \
    bc \
    curl \
    dnsutils \
    git \
    htop \
    iftop \
    inetutils-ping \
    iotop \
    mtr \
    nethogs \
    net-tools \
    nmap \
    pv \
    strace \
    sudo \
    tmux \
    traceroute \
    vim \
    wget \
  && echo "deb [trusted=yes] https://repo.iovisor.org/apt/xenial xenial-nightly main" \
    | tee /etc/apt/sources.list.d/iovisor.list \
  && apt-get update -qy \
  && apt-get install -qy  \
    bcc-tools \
  && rm -rf /var/lib/apt/lists/*

# Install .files
COPY .files /root/.files/
RUN yes | $HOME/.files/install.sh

# Final runtime env setup
WORKDIR /root
CMD tmux

