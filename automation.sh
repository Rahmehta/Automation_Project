#!/bin/bash

# check and install the apache server
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

# intalling AWSCLI and copying the tar file
sudo apt update
sudo apt install awscli


#fetching the current time stamp
timeStamp=$(date '+%d%m%Y-%H%M%S')

# making the tar file of log files and copying it on AWS S3 bucket
tar -cvf /tmp/Rahul-httpd-$timeStamp.tar /var/log/apache2/ |aws s3 cp /tmp/Rahul-httpd-$timeStamp.tar  \s3://upgrad-rahul/Rahul-httpd-$timeStamp.tar

#size = $(stat -c %s /tmp/Rahul-httpd-$timeStamp.tar )


#check if inventory file exits and  appending with log data
if [ -f /var/www/html/inventory.html ]
then
echo -e  "httpd-logs \t $timeStamp \t tar \t 10 KB  "  >> /var/www/html/inventory.html
else
cat /var/www/html/inventory.html | echo -e 'Log Type \t Time Created \t \t Type \t Size' >> /var/www/html/inventory.html
echo -e  "httpd-logs \t $timeStamp \t tar \t  10 KB  "  >> /var/www/html/inventory.html
fi
