FROM alpine:latest as builder

RUN apk add --no-cache gcc g++ linux-headers make openssl-dev openssl-libs-static
RUN wget -qO- https://github.com/pymumu/smartdns/archive/refs/heads/master.zip | unzip -d / -
RUN cd /smartdns-master && make -j && strip --strip-all src/smartdns


FROM alpine:latest

RUN apk add --no-cache openssl libgcc
COPY --from=builder /smartdns-master/etc/smartdns /etc/smartdns
COPY --from=builder /smartdns-master/src/smartdns /usr/local/bin/smartdns

ENTRYPOINT ["smartdns", "-f", "-x"]

