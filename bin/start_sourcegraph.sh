#!/usr/bin/sh

#--volume $HOME/dot/sgsync:/etc/sourcegraph_dot \

docker run --publish 7080:7080 --rm \
  --publish 127.0.0.1:3370:3370 \
  -e EXTSVC_CONFIG_FILE=/var/opt/sourcegraph/repos.json \
  -e SOURCEGRAPHDOTCOM_MODE=true \
  --volume $HOME/.sourcegraph/config:/etc/sourcegraph \
  --volume $HOME/.sourcegraph/data:/var/opt/sourcegraph \
  sourcegraph/server:3.43.1
