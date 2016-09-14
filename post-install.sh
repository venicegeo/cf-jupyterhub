#!/bin/bash

pushd /tmp
/usr/bin/npm install node_modules/configurable-http-proxy/ -g
/usr/bin/python3 get-pip.py
/usr/bin/pip3.4 install --no-index --find-links gsjhub-modules/ -r /tmp/requirements.txt
popd

# Create hubadmin user and give sudo
useradd -r -M gsjhub -s /sbin/nologin
chown -R gsjhub:gsjhub {/etc/gsjhub,/var/run/gsjhub}

tee -a /etc/sudoers <<-'EOF'
# --BEGIN gsjhub--#
Cmnd_Alias JUPYTER_CMDS = /usr/bin/sudospawner, /usr/sbin/useradd
gsjhub ALL=(ALL) NOPASSWD:JUPYTER_CMDS
# --END gsjhub--#
EOF
systemctl daemon-reload
