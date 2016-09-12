#!/bin/bash

# We build our own Python from source so we can locate it 
# in /opt/gsjhub and not touch the system python
# This runs after the rpm does its thing because
# we need the source files in place to continue

# Build a stand-alone Python 3.4 Executable
echo "Installing python and pip..."

pushd /tmp
tar xvf Python-3.4.5.tgz
pushd Python-3.4.5
./configure
make altinstall prefix=/opt/gsjhub exec-prefix=/opt/gsjhub
popd
popd

pushd /opt/gsjhub
bin/python3.4 /tmp/get-pip.py
bin/pip3.4 install --upgrade pip
bin/pip3.4 install --upgrade
bin/pip3.4 install --upgrade -r /tmp/requirements.txt

# Clean up source files
rm -rf /tmp/requirements.txt
rm -rf /tmp/get-pip.py
rm -rf /tmp/Python-3.4.5.tgz
rm -rf /tmp/Python-3.4.5

# @TODO Create hubadmin user and give sudo
# Add env variables for hubadmin
# Maybe a start.sh script that is started from the systemd file?
useradd -r -M gsjhub -s /sbin/nologin
chown -R gsjhub:gsjhub {/opt/gsjhub,/etc/gsjhub}

