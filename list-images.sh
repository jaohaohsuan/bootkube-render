#!/bin/bash
set -e
dir=`mktemp -d -u`

bootkube render --asset-dir=$dir --api-servers=https://127.0.0.1:443 --etcd-servers=http://127.0.0.1:2379 --self-host-kubelet &> /dev/null
cp -r /manifests/* $dir/manifests

touch $dir/images

for f in `grep -rw $dir/manifests --include=\*.{yaml,yml,json,list} -e "image:" | awk -F ':' '{print $1}' | uniq`
  do
  for src in `sed -n 's/image: \([a-z]\+\)/\1/p' $f | tr -d ' ' | uniq`
    do
    if [ ! -z "$TAG_PREFIX" ] && echo "$src" | grep -qE '^(gcr|quay)'; then
      tag=$TAG_PREFIX/$(echo $src | awk -F '/' '{print $3}')
      echo "$tag $src" >>  $dir/images 
    else
      echo "$src $src" >>  $dir/images 
    fi
  done
done

#bootkube_image=quay.io/coreos/bootkube:v0.3.1
#[ -z "$TAG_PREFIX" ] && echo "$bootkube_image $bootkube_image" || echo "$TAG_PREFIX/`echo $bootkube_image | awk -F '/' '{print $NF}'` $bootkube_image" >> $dir/images
awk '!seen[$0]++' $dir/images > $dir/no-duplicate
cp $dir/no-duplicate /out/images
