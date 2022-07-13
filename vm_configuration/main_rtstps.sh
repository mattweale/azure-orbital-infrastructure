#!/bin/bash

 echo "From rtstps_main.sh the client.id of the MI is ${AQUA_MI_ID}"

sudo ./mount_data_drive.sh
sudo ./mount_container.sh
sudo ./rtstps_install.sh