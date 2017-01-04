#!/bin/bash
set -ex
dir=/asset
/bin/linux/bootkube render --asset-dir=$dir --api-servers=$BOOTKUBE_API_SERVERS --etcd-servers=BOOTKUBE_ETCD_SERVERS --self-host-kubelet
cp -r /manifests/* $dir/manifests
for f in `grep -rw $dir/manifests --include=\*.{yaml,yml,json} -e "image:" | awk -F ':' '{print $1}' | uniq`
  do
  for i in `sed -n 's/image: \([a-z]\+\)/\1/p' $f | tr -d ' ' | uniq`
    do
    #docker pull $i &> /dev/null;
    if [[ $(echo "$i" | grep -E '^(gcr|quay)') ]]; then
      tag=henryrao/$(echo $i | awk -F '/' '{print $3}')
      echo "$i -> $tag"
      #docker tag $i $tag;
      #docker push $tag &> /dev/null;
      sed -i 's/image: \(.*\)\/\(.*\:.*\)/image: henryrao\/\2/g' $f
    else
      echo "- $i"
    fi
  done
done
tar -zcvf /asset.tar $dir -P
cp /asset.tar /out/asset.tar
