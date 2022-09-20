#!/bin/bash
set -e

TAG=${1:-latest}
docker build . -t ankitwal/iat-terraform-aws:${TAG}
docker push ankitwal/iat-terraform-aws:${TAG}
