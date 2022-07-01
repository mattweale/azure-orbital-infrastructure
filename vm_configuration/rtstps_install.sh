#!/bin/bash

#	=============================
#	RT-STPS Install
#	=============================

#   Install az copy
cd ~
curl "https://azcopyvnext.azureedge.net/release20220315/azcopy_linux_amd64_10.14.1.tar.gz" > azcopy_linux_amd64_10.14.1.tar.gz
tar -xvf azcopy_linux_amd64_10.14.1.tar.gz
cp ./azcopy_linux_amd64_*/azcopy /usr/bin/

#	Apply Udates
	sudo yum upgrade -y 
	
# 	Install XRDP Server
	sudo yum install -y epel-release
	sudo yum groupinstall -y "Server with GUI"
	sudo yum groupinstall -y "Gnome Desktop"
	sudo yum install -y tigervnc-server xrdp	
	sudo systemctl enable xrdp.service
	sudo systemctl start xrdp.service
	sudo systemctl set-default graphical.target

#	Check if RT-STPS is installed already
if [ -d "/root/rt-stps" ]; then
	export NOW=$(date '+%Y%m%d-%H:%M:%S')
	echo "$NOW	RT-STPS already installed, skipping installation"
else
	export NOW=$(date '+%Y%m%d-%H:%M:%S')
	echo "$NOW	RT-STPS Prerequisites"
	
#	Install JDK
#	sudo yum install -y java-11-openjdk-devel
	
#   Set JAVA Environment Variables
#	export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
#	export PATH=$PATH:$JAVA_HOME/bin

#   Download RT_STPS Software and Test Data
	export CONTAINER='https://samrw.blob.core.windows.net/rt-stps/'
	export SAS_TOKEN='?sp=rl&st=2022-06-06T18:11:00Z&se=2023-06-07T02:11:00Z&spr=https&sv=2021-06-08&sr=c&sig=9jcQ%2B7STJjGnoA8NGD1CVtBEDhLDCwm3XVFuE1mLsGk%3D'
	export SOURCE_DIR=/datadrive
	export RTSTPS_DIR=/datadrive/rt-stps/

	azcopy login --identity --identity-client-id "f1314747-ea4f-4f0a-92ba-fd0b5dc953a0"

	azcopy cp "${CONTAINER}RT-STPS_7.0.tar.gz" "$SOURCE_DIR"
	azcopy cp "${CONTAINER}RT-STPS_7.0_testdata.tar.gz" "$SOURCE_DIR"
	azcopy cp "${CONTAINER}test2.bin$" "$SOURCE_DIR"

#	azcopy cp "${CONTAINER}RT-STPS_6.0.tar.gz${SAS_TOKEN}" "$SOURCE_DIR"
#	azcopy cp "${CONTAINER}RT-STPS_6.0_PATCH_1.tar.gz${SAS_TOKEN}" "$SOURCE_DIR"
#	azcopy cp "${CONTAINER}RT-STPS_6.0_PATCH_2.tar.gz${SAS_TOKEN}" "$SOURCE_DIR"
#	azcopy cp "${CONTAINER}RT-STPS_6.0_PATCH_3.tar.gz${SAS_TOKEN}" "$SOURCE_DIR"
#	azcopy cp "${CONTAINER}RT-STPS_6.0_testdata.tar.gz${SAS_TOKEN}" "$SOURCE_DIR"
#	azcopy cp "${CONTAINER}test2.bin${SAS_TOKEN}" "$SOURCE_DIR"

#	Could use this but need to tidy up Container
#	azcopy $RTSTPS_SOURCE $RTSTPS_DIR --recursive --overwrite --log-level=error

# 	Install RT-STPS
	cd $SOURCE_DIR
	tar -xzvf RT-STPS_7.0.tar.gz
	#	tar -xzvf RT-STPS_6.0.tar.gz
	cd rt-stps
	./install.sh

# 	Install patches
#	cd $SOURCE_DIR
#	tar -xzvf RT-STPS_6.0_PATCH_1.tar.gz 
#	tar -xzvf RT-STPS_6.0_PATCH_2.tar.gz 
#	tar -xzvf RT-STPS_6.0_PATCH_3.tar.gz
#	sudo chown -R adminuser /datadrive
#	sudo chgrp -R adminuser /datadrive

# 	Update leadsec file
	cd /datadrive/rt-stps
	./bin/internal/update_leapsec.sh

fi

# 	Echo how to start RT-STPS, Viewer and Sender
	echo 'Start RT-STPS Server with: ./rt-stps/jsw/bin/rt-stps-server.sh start'
	cd /datadrive
	./rt-stps/jsw/bin/rt-stps-server.sh start
	echo 'Start Viewer with: ./rt-stps/bin/viewer.sh &'
	echo 'Start Sender with: ./rt-stps/bin/sender.sh &'