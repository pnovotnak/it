FROM golang:1 as fortio-builder

# We care more about caching efficency than layers
RUN set -ex; \
  apt-get update; \
  apt-get install -qy libcap2-bin

RUN set -ex; \
  go get fortio.org/fortio; \
  cd /go/src/fortio.org/fortio; \
  git fetch --tags; \
  git checkout latest_release; \
  make submodule-sync; \
  make official-build-version \
    OFFICIAL_BIN=~/go/bin/fortio; \
  setcap 'cap_net_bind_service=+ep' `which fortio`; \
  fortio version

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

COPY --from=fortio-builder /go/bin/fortio /usr/local/bin/fortio

# Final runtime env setup
WORKDIR /root
CMD tmux

