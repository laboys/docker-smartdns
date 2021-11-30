FROM alpine:latest as builder

RUN set -ex \
    && apk add --no-cache --virtual .build-deps curl gcc g++ linux-headers make openssl-dev \
    \
    && mkdir -p /usr/src \
    && curl -SL https://github.com/pymumu/smartdns/archive/refs/heads/master.zip -o smartdns.zip \
    \
    && unzip smartdns.zip -d /usr/src \
    && rm -rf smartdns.zip \
    \
    && cd /usr/src/smartdns-master \
    && sed -i 's|/etc/smartdns|/usr/local/smartdns/conf|g' src/dns_conf.h \
    && make -j \
    \
    && strip --strip-all src/smartdns


FROM alpine:latest

RUN set -ex \
    && apk add --no-cache openssl libgcc \
    && mkdir -p /usr/local/smartdns/bin \
    && mkdir -p /usr/local/smartdns/conf

COPY --from=builder /usr/src/smartdns-master/etc/smartdns/smartdns.conf /usr/local/smartdns/conf
COPY --from=builder /usr/src/smartdns-master/src/smartdns /usr/local/smartdns/bin

RUN set -ex \
    && ln -s /usr/local/smartdns/bin/smartdns /usr/local/bin

ENTRYPOINT ["smartdns", "-f", "-x"]
