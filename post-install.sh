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

# Clean up source directory since FPM doesn't know about it and
# can't remove it during the package process.
rm -rf /tmp/Python-3.4.5

# @TODO Create hubadmin user and give sudo
useradd -r -M gsjhub -s /sbin/nologin
chown -R gsjhub:gsjhub {/opt/gsjhub,/etc/gsjhub}

tee -a /etc/sudoers <<-'EOF'
# --BEGIN gsjhub--#
Cmnd_Alias JUPYTER_CMDS = /opt/gsjhub/bin/sudospawner, /sbin/useradd
gsjhub ALL=(ALL) NOPASSWD:JUPYTER_CMDS
# --END gsjhub--#
EOF
systemctl daemon-reload
