FROM alpine:3.5
RUN apk --update add tar wget bash grep ca-certificates curl openssl && \
  wget -q --no-check-certificate -P / https://github.com/kubernetes-incubator/bootkube/releases/download/v0.3.1/bootkube.tar.gz && \
  tar xvf /bootkube.tar.gz bin/linux/bootkube -C /

ENV PATH=$PATH:/bin/linux

ENV DOCKER_BUCKET get.docker.com
ENV DOCKER_VERSION 1.12.5
ENV DOCKER_SHA256 0058867ac46a1eba283e2441b1bb5455df846144f9d9ba079e97655399d4a2c6

RUN set -x \
  && curl -fSL "https://${DOCKER_BUCKET}/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz" -o docker.tgz \
  && echo "${DOCKER_SHA256} *docker.tgz" | sha256sum -c - \
  && tar -xzvf docker.tgz \
  && mv docker/* /usr/local/bin/ \
  && rmdir docker \
  && rm docker.tgz \
  && docker -v

ADD manifests /manifests
ADD tar_asset.sh /tar_asset.sh
ADD retag.sh /retag.sh
ADD list-images.sh /list-images.sh
#ENTRYPOINT ["/entrypoint.sh"]
VOLUME ["/out"]
ENV BOOTKUBE_API_SERVERS=https://127.0.0.1:443 
ENV BOOTKUBE_ETCD_SERVERS=http://127.0.0.1:2379
ENV TAG_PREFIX=127.0.0.1:5000/prod
