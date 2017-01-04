FROM alpine:3.5
RUN apk --update add tar wget bash grep && \
  wget -q --no-check-certificate -P / https://github.com/kubernetes-incubator/bootkube/releases/download/v0.3.1/bootkube.tar.gz && \
  tar xvf /bootkube.tar.gz bin/linux/bootkube -C /
ADD calico.yaml /manifests/calico.yaml
ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
VOLUME ["/out"]
ENV BOOTKUBE_API_SERVERS=https://127.0.0.1:443 
ENV BOOTKUBE_ETCD_SERVERS=http://127.0.0.1:2379
ENV TAG_PREFIX=127.0.0.1:5000/prod
