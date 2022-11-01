#!/bin/bash

# check and install the apache server.
ServerInstall = $(apache2 -v)
if [[ $ServerInstall == *"version: Apache"* ]]; 
then
  break
else 
	sudo apt update -y
	sudo apt install apache2
fi

# check. start and enable the apache server
ServerStatusCheck =$(service apache2 status)

if [[ $ServerStatusCheck == *"active (running)"* ]]; 
then
  break
else 
	sudo systemctl start apache2.service
	sudo systemctl enable apache2.service
fi

# making the tar file of log files
tar -cvf /tmp/Rahul-httpd-$(date '+%d%m%Y-%H%M%S').tar /var/log/apache2/

# Copying to the S3 bucket will require AWS Command Line Interface (CLI)  to be installed in the system.
sudo apt update
sudo apt install awscli
aws s3 cp /tmp/Rahul-httpd-01112022-040711.tar  \s3://upgrad-rahul/rahul-httpd-$(date '+%d%m%Y-%H%M%S').tar
