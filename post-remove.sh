#!/bin/bash

userdel -r gsjhub
rm -rf /opt/gsjhub
rm -rf /etc/gsjhub
systemctl disable gsjhub
systemctl stop gsjhub
rm /usr/lib/systemd/system/gsjhub.service
# Systemd daemon reload?


