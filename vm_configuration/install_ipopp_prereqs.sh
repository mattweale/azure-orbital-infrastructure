#!/bin/bash

# =============================
# IPOPP Install
# =============================

#	Check that /datadrive is mounted
if [ ! -d "/datadrive" ]; then
	export NOW=$(date '+%Y%m%d-%H:%M:%S')
	echo "$NOW	/datadrive does not exist. Run mount_drive.sh"
else
	export NOW=$(date '+%Y%m%d-%H:%M:%S')
	echo "$NOW	IPOPP Prerequisites"

#   Install az copy
	echo "Now let's install azcopy"
	cd ~
	curl "https://azcopyvnext.azureedge.net/release20220315/azcopy_linux_amd64_10.14.1.tar.gz" > azcopy_linux_amd64_10.14.1.tar.gz
	tar -xvf azcopy_linux_amd64_10.14.1.tar.gz
	sudo cp ./azcopy_linux_amd64_*/azcopy /usr/bin/
	sudo chmod 755 /usr/bin/azcopy

#	Apply Udates
	echo "Now let's upgrade packages"
	sudo yum upgrade -y 
	
# 	Install XRDP Server
	echo "Now let's install XRDP"
	sudo yum install -y epel-release
	sudo yum groupinstall -y "Server with GUI"
	sudo yum groupinstall -y "Gnome Desktop"
	sudo yum install -y tigervnc-server xrdp	
	sudo systemctl enable xrdp.service
	sudo systemctl start xrdp.service
	sudo systemctl set-default graphical.target

#   Download IPOPP Software and Patch.
	echo "Now let's install IPOPP and Patches"
	export CONTAINER="https://${AQUA_TOOLS_SA}.blob.core.windows.net/ipopp/"
	export SOURCE_DIR=/datadrive
	export INSTALL_DIR=/datadrive/IPOPP

	azcopy login --identity --identity-client-id ${AQUA_MI_ID}

	azcopy cp "${CONTAINER}DRL-IPOPP_4.1.tar.gz" "$SOURCE_DIR"
	azcopy cp "${CONTAINER}DRL-IPOPP_4.1_PATCH_1.tar.gz" "$SOURCE_DIR"
	azcopy cp "${CONTAINER}DRL-IPOPP_4.1_PATCH_2.tar.gz" "$SOURCE_DIR"

 	cp -a /var/lib/waagent/custom-script/download/0/install_ipopp_prepare.sh /datadrive/install_ipopp_prepare.sh
	sudo chown -R adminuser /datadrive
	sudo chgrp -R adminuser /datadrive

fi