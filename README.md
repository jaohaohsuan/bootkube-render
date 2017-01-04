# bootkube-render

利用`bootkube redner`出来的`manifests`, 把非docker hub上的image重新打上tag，并取代原有的iamge名称，最后打包成`asset.tar`

## addons
用户可自行添加manifests档案

## build

```
docker build -t bootkube-render:latest .
```

## how to use

```
docker run --rm -v `pwd`/out:/out \
 -e "BOOTKUBE_ETCD_SERVERS=https://192.168.60.125:2379" \ 
 -e "BOOTKUBE_API_SERVERS=https://192.168.60.125:443" \
 -e "TAG_PREFIX=henryrao" \
 bootkube-render:latest
```
