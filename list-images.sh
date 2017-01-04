#!/bin/bash
set -e
dir=`mktemp -d -u`

bootkube render --asset-dir=$dir --api-servers=https://127.0.0.1:443 --etcd-servers=http://127.0.0.1:2379 --self-host-kubelet &> /dev/null
cp -r /manifests/* $dir/manifests

touch $dir/images

for f in `grep -rw $dir/manifests --include=\*.{yaml,yml,json} -e "image:" | awk -F ':' '{print $1}' | uniq`
  do
  for i in `sed -n 's/image: \([a-z]\+\)/\1/p' $f | tr -d ' ' | uniq`
    do
    if [[ $(echo "$i" | grep -E '^(gcr|quay)') ]]; then
      tag=$TAG_PREFIX/$(echo $i | awk -F '/' '{print $3}')
      echo "$tag" >>  $dir/images 
    else
      echo "$i" >>  $dir/images 
    fi
  done
done
cp $dir/images /out/
