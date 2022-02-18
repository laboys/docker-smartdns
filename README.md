# docker-smartdns

smartdns minimalist image based on alpine.


### Installation

You can use this image with the following command
```bash
docker run --name my-smartdns -d \
    -p 53:53/udp \
    -v /path/to/your/smartdns.conf:/etc/smartdns/smartdns.conf \
    laboys/smartdns
```

The smartdns program is started by default with the `-f -x` arguments which means it runs in the foreground and outputs the verbose logging, to view the log you can use the following command
```bash
docker logs --tail=100 -f my-smartdns
```


### License

Released under the [MIT License](LICENSE)

