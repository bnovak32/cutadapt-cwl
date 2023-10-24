FROM ubuntu:22.04
ARG cutadapt_version=4.2

ENV DEBIAN_FRONTEND noninteractive

ADD https://bootstrap.pypa.io/get-pip.py /tmp/get-pip.py

RUN set -e \
      && ln -sf bash /bin/sh \
      && ln -s python3 /usr/bin/python

RUN  apt-get -y update && apt-get -y dist-upgrade \
  && apt-get -y install --no-install-recommends --no-install-suggests gcc python3-dev python3-distutils \
  && apt-get -y autoremove && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN  /usr/bin/python3 /tmp/get-pip.py \
  && pip install -U --no-cache-dir pip cutadapt==${cutadapt_version} \
  && rm -f /tmp/get-pip.py

