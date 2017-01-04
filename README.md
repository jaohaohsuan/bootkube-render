# bootkube-render

## feature

- 用户可自行添加manifests档案
- 利用`bootkube redner`出来的`manifests`, 把非docker hub上的image重新打上tag，并取代原有的iamge名称，最后打包成`asset.tar`.
- 因应GFW, 先把gcr跟quay.io, 重新tag并push到官方docker hub, 再利用docker mirror(自建或用daocloud加速器)进行高速下载.

## build

```
docker build -t bootkube-render:latest .
```

## tar asset

```
docker run --rm 
           -v `pwd`/out:/out \
           -e "BOOTKUBE_ETCD_SERVERS=https://192.168.60.125:2379" \ 
           -e "BOOTKUBE_API_SERVERS=https://192.168.60.125:443" \
           -e "TAG_PREFIX=henryrao" \
           bootkube-render:latest /tar_asset.sh
```

## retag and push

```
docker run --rm \
           -v /var/run/docker.sock:/var/run/docker.sock \
           -v /usr/bin/docker:/usr/bin/docker \
           -v /usr/lib64/:/opt/lib64/ \
           -v /root/.docker/config.json:/root/.docker/config.json \
           -e TAG_PREFIX=henryrao \
           --net=host \
           --pid=host \
           --privileged \
           bootkube-render:latest /retag.sh
```
