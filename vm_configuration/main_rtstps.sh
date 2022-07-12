#!/bin/bash

echo $AQUA_MI_ID

sudo ./mount_data_drive.sh
sudo ./mount_container.sh
sudo ./rtstps_install.sh