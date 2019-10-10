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
RUN set -ex; \
  apt-get update; \
  apt-get install -qy \
    apt-transport-https \
    bc \
    bpfcc-tools \
    curl \
    dnsutils \
    git \
    htop \
    iftop \
    inetutils-ping \
    iotop \
    mtr \
    netcat \
    nethogs \
    net-tools \
    nmap \
    pv \
    strace \
    sudo \
    tcpdump \
    tmux \
    traceroute \
    vim \
    wget; \
  rm -rf /var/lib/apt/lists/* ; \
  curl -Lo /usr/local/bin/kubectl \
    https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl; \
  chmod +x /usr/local/bin/kubectl

# Install .files
COPY .files /root/.files/
RUN yes | $HOME/.files/install.sh

COPY --from=fortio-builder /go/src/fortio.org/fortio/ui/templates /go/src/fortio.org/fortio/ui/templates
COPY --from=fortio-builder /go/bin/fortio /usr/local/bin/fortio

# Final runtime env setup
WORKDIR /root
CMD tmux

