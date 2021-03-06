#!/bin/bash
set -ex
dir=`mktemp -d -u`
bootkube render --asset-dir=$dir --api-servers=$BOOTKUBE_API_SERVERS --etcd-servers=$BOOTKUBE_ETCD_SERVERS --self-host-kubelet
find /manifests \! -name '*.list' -type f -exec cp {} $dir/manifests \;
#for f in `grep -rw $dir/manifests --include=\*.{yaml,yml,json} -e "image:" | awk -F ':' '{print $1}' | uniq`
#  do
#  for i in `sed -n 's/image: \([a-z]\+\)/\1/p' $f | tr -d ' ' | uniq`
#    do
#    if [ ! -z "$TAG_PREFIX" ] && echo "$i" | grep -qE '^(gcr|quay)'; then
#      tag=$TAG_PREFIX/$(echo $i | awk -F '/' '{print $3}')
#      echo "$i -> $tag"
#      sed -i 's/image: \(.*\)\/\(.*\:.*\)/image: '$TAG_PREFIX'\/\2/g' $f
#    else
#      echo "- $i"
#    fi
#  done
#done
cd $dir
tar -zcvf /asset.tar ./ -P
cp $dir/auth/kubeconfig /out/
chmod +r /out/kubeconfig
cp /asset.tar /out/asset.tar
