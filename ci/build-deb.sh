#!/bin/bash
export EXT=deb
export APP=gsjhub
pushd `dirname $0`/.. > /dev/null
root=$(pwd -P)
$root/build.sh deb
popd > /dev/null

