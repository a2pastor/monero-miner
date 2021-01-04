# monero-miner

Dockerfile for https://hub.docker.com/r/kannix/monero-miner/
this docker image uses [XMRig](https://github.com/xmrig/xmrig)

Added ENV variables and force the use of TLS on port 443

## Build
```
docker build -t docker-xmrig-tls .
```

## Run
```
docker run -idt docker-xmrig-tls
```


Accepts ENV variables:
- POOL_URL= Pool server, should support TLS. (e.g. pool.supportxmr.com:443)
- POOL_USER= wallet address
- POOL_PW= Password (only needed to identify the instance)
Example:
```
docker run -idt -e POOL_URL=pool.supportxmr.com docker-xmrig-tls
```

## Monitor
```
docker attach <container-id>
```
  press keys: 
-    h -> Hash performance
-    r -> Report
-    e -> Errors  
