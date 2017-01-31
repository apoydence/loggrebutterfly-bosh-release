#!/bin/bash
set -e

workspace=$(git rev-parse --show-toplevel)
export GOPATH=$workspace

echo "building loggrebutterfly data node"
GOOS=linux go build -o $workspace/datanode github.com/apoydence/loggrebutterfly/datanode
gzip -f $workspace/datanode

echo "building loggrebutterfly master"
GOOS=linux go build -o $workspace/master github.com/apoydence/loggrebutterfly/master
gzip -f $workspace/master

pushd $workspace > /dev/null
  bosh add-blob ./datanode.gz loggrebutterfly/datanode.gz > /dev/null
  bosh add-blob ./master.gz loggrebutterfly/master.gz > /dev/null
  rm datanode.gz master.gz >> /dev/null
popd > /dev/null
