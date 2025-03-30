#!/usr/bin/env sh

OLDIFS=$IFS
IFS=''
for file in *; do
    echo "$PWD/$file"
    echo "$PWD/$file" > ~/tmp/preview.fifo
    sleep 4
done
IFS=$OLDIFS

