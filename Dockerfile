FROM ubuntu:xenial

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qy \
  && apt-get install -qy \
    apt-transport-https \
    wget \
    nmap \
    traceroute \
    mtr \
    strace \
    iotop \
    iftop \
    nethogs \
    htop \
  && apt-get update -qy \
  && echo "deb [trusted=yes] https://repo.iovisor.org/apt/xenial xenial-nightly main" \
    | tee /etc/apt/sources.list.d/iovisor.list \
  && apt-get install -qy  \
    bcc-tools \
  && rm -rf /var/lib/apt/lists/*

