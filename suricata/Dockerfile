FROM ubuntu:22.04 AS builder

ARG SURICATA_VERSION="6.0.8"
ARG SURICATA_UPDATE_VERSION="1.2.5"
ARG LIBHTP_VERSION="0.5.41"

RUN apt-get update && apt-get -y install \
    autoconf \
    automake \
    build-essential \
    cargo \
    curl \
    git-core \
    jq \
    libcap-ng-dev \
    libcap-ng0 \
    libjansson-dev \
    liblz4-dev \
    libmagic-dev \
    libnet1-dev \
    libnetfilter-queue-dev \
    libnetfilter-queue1 \
    libnfnetlink-dev \
    libnfnetlink0 \
    libnspr4-dev \
    libnss3-dev \
    libpcap-dev \
    libpcre3 \
    libpcre3-dbg \
    libpcre3-dev \
    libtool \
    libyaml-0-2 \
    libyaml-dev \
    make \
    pkg-config \
    python3 \
    python3-distutils \
    python3-yaml \
    rustc \
    zlib1g \
    zlib1g-dev

RUN cargo install --root /usr/local cbindgen

FROM builder as suricata

WORKDIR /suricata

RUN git clone https://github.com/OISF/suricata.git -b suricata-${SURICATA_VERSION} --depth 1 suricata && \
    git clone https://github.com/OISF/libhtp.git -b ${LIBHTP_VERSION} --depth 1  suricata/libhtp

WORKDIR /suricata/suricata

RUN ./autogen.sh

RUN ./configure --disable-shared && \
    make -j $(nproc) && \
    make install install-conf

FROM builder as suricata-update

RUN git clone https://github.com/OISF/suricata-update.git -b ${SURICATA_UPDATE_VERSION} suricata-update --depth 1

WORKDIR /suricata-update

RUN python3 setup.py build && \
    python3 setup.py install

FROM builder as final

COPY --from=suricata /usr/local/bin/suricata /usr/local/bin/suricata
COPY --from=suricata /usr/local/bin/suricatactl /usr/local/bin/suricatactl
COPY --from=suricata /usr/local/bin/suricatasc /usr/local/bin/suricatasc
COPY --from=suricata /usr/local/etc/suricata /usr/local/etc/suricata
COPY --from=suricata /usr/local/var/log/suricata /usr/local/var/log/suricata
COPY --from=suricata /usr/local/var/run/suricata /usr/local/var/run/suricata
COPY --from=suricata-update /usr/local/bin/suricata-update /usr/local/bin/suricata-update
COPY --from=suricata-update /usr/local/lib/ /usr/local/lib/

COPY ./etc/suricata.yaml usr/local/etc/suricata/suricata.yaml

RUN suricata-update update-sources && \
    suricata-update enable-source oisf/trafficid && \
    suricata-update --no-test --no-reload

COPY ./docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT /docker-entrypoint.sh