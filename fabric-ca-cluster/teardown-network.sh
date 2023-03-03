#!/bin/bash
set -e
set -x

docker rm -f root-ca
docker rm -f intermediate-ca-1
docker rm -f intermediate-ca-2
docker rm -f ca-db
docker rm -f ca-client

# Clean data dir
rm -rf ./data
