#!/bin/bash
export EXT=rpm
export APP=gsjhub
pushd `dirname $0`/.. > /dev/null
root=$(pwd -P)
$root/build.sh rpm
popd > /dev/null

