#!/bin/bash
set -e
set -x

container_name=$1
expected_text=$2

echo "Waiting for $expected_text in $container_name logs"

while ! (docker logs "$container_name" 2>&1 | grep "$expected_text") ; do
  sleep 1
done

echo "Success!"

