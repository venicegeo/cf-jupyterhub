#!/bin/bash

#systemctl disable gsjhub
#systemctl stop gsjhub
userdel -r gsjhub
rm -rf /opt/gsjhub
#rm /etc/systemd/system/gsjhub.service
systemctl daemon-reload
# Remove the gsjhub from the sudoers file
sed -i '/# --BEGIN gsjhub--#/,/# --END gsjhub--#/d' /etc/sudoers


