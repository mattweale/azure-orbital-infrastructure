#!/bin/bash

echo "From main_rtstps.sh the client.id of the MI is ${AQUA_MI_ID}"

sudo ./mount_data_drive.sh
sudo ./mount_container.sh
sudo -E bash -c ./rtstps_install.sh