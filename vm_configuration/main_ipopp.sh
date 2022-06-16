#!/bin/bash

sudo ./mount_data_drive.sh
sudo ./mount_container.sh
sudo ./install_ipopp_prereqs.sh
su -c "/datadrive/install_ipopp_prepare.sh" -s /bin/bash adminuser