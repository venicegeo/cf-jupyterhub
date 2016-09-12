#!/bin/bash

systemctl disable gsjhub
systemctl stop gsjhub
systemctl disable gsjhub
userdel -r gsjhub
rm -rf /opt/gsjhub
rm -rf /etc/gsjhub
rm /etc/systemd/system/gsjhub.service
systemctl daemon-reload
# Remove the gsjhub from the sudoers file
sed -i '/# --BEGIN gsjhub--#/,/# --END gsjhub--#/d' /etc/sudoers


