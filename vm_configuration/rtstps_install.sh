#!/bin/bash

#	=============================
#	RT-STPS Install
#	=============================

	echo "Now on the RT-STPS Install"
	echo "First let's install azcopy"
#   Install az copy
	cd ~
	curl "https://azcopyvnext.azureedge.net/release20220315/azcopy_linux_amd64_10.14.1.tar.gz" > azcopy_linux_amd64_10.14.1.tar.gz
	tar -xvf azcopy_linux_amd64_10.14.1.tar.gz
	cp ./azcopy_linux_amd64_*/azcopy /usr/bin/

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

#	Check if RT-STPS is installed already.
if [ -d "/root/rt-stps" ]; then
	export NOW=$(date '+%Y%m%d-%H:%M:%S')
	echo "$NOW	RT-STPS already installed, skipping installation"
else
	export NOW=$(date '+%Y%m%d-%H:%M:%S')
	echo "$NOW sorting the RT-STPS Prerequisites"
	
	
#   Download RT_STPS Software and Test Data
	echo "Now let's download RT-STPS v7.0 and  some test data"
	export CONTAINER="https://${AQUA_TOOLS_SA}.blob.core.windows.net/rt-stps/"
	export SOURCE_DIR=/datadrive
	export RTSTPS_DIR=/datadrive/rt-stps/

	azcopy login --identity --identity-client-id ${AQUA_MI_ID}
	
	azcopy cp "${CONTAINER}RT-STPS_7.0.tar.gz" "$SOURCE_DIR"
	azcopy cp "${CONTAINER}RT-STPS_7.0_testdata.tar.gz" "$SOURCE_DIR"
	azcopy cp "${CONTAINER}test2.bin" "$SOURCE_DIR"

#	azcopy cp "${CONTAINER}RT-STPS_6.0.tar.gz${SAS_TOKEN}" "$SOURCE_DIR"
#	azcopy cp "${CONTAINER}RT-STPS_6.0_PATCH_1.tar.gz${SAS_TOKEN}" "$SOURCE_DIR"
#	azcopy cp "${CONTAINER}RT-STPS_6.0_PATCH_2.tar.gz${SAS_TOKEN}" "$SOURCE_DIR"
#	azcopy cp "${CONTAINER}RT-STPS_6.0_PATCH_3.tar.gz${SAS_TOKEN}" "$SOURCE_DIR"
#	azcopy cp "${CONTAINER}RT-STPS_6.0_testdata.tar.gz${SAS_TOKEN}" "$SOURCE_DIR"
#	azcopy cp "${CONTAINER}test2.bin${SAS_TOKEN}" "$SOURCE_DIR"

# 	Install RT-STPS
	echo "Now let's install RT-STPS v7.0"
	cd $SOURCE_DIR
	tar -xzvf RT-STPS_7.0.tar.gz
	#	tar -xzvf RT-STPS_6.0.tar.gz
	cd rt-stps
	./install.sh

# 	Update leapsec file
	cd /datadrive/rt-stps
	./bin/internal/update_leapsec.sh

fi

# 	Echo how to start RT-STPS, Viewer and Sender
	echo 'Start RT-STPS Server with: ./rt-stps/jsw/bin/rt-stps-server.sh start'
	cd /datadrive
	./rt-stps/jsw/bin/rt-stps-server.sh start
	echo 'Start Viewer with: ./rt-stps/bin/viewer.sh &'
	echo 'Start Sender with: ./rt-stps/bin/sender.sh &'