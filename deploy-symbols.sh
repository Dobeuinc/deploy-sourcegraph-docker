#!/usr/bin/env bash
set -e
source ./replicas.sh

# Description: Backend for symbols operations.
#
# Disk: 128GB / non-persistent SSD
# Network: 100mbps
# Liveness probe: none
# Ports exposed to other Sourcegraph services: 3184/TCP 6060/TCP
# Ports exposed to the public internet: none
#
VOLUME="$HOME/sourcegraph-docker/symbols-$1-disk"
./ensure-volume.sh $VOLUME 100
docker run --detach \
    --name=symbols-$1 \
    --network=sourcegraph \
    --restart=always \
    --cpus=2 \
    --memory=4g \
    -e GOMAXPROCS=2 \
    -e SRC_FRONTEND_INTERNAL=sourcegraph-frontend-internal:3090 \
    -e JAEGER_AGENT_HOST=jaeger \
    -v $VOLUME:/mnt/cache \
    index.docker.io/sourcegraph/symbols:3.27.4@sha256:0a3ef66f6d470268de3807de4cc49af9d3753d6a14f682bf83eda66d08f27e34

echo "Deployed symbols $1 service"
