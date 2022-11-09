# Automation_Project

Task 1: Set Up Necessary Infrastructure


----Create an IAM role, a security group, an S3 bucket and launch an EC2 instance.
	--- Search for IAM service in search bar
	--- I named it as "Rahul_CourseAssignment" and tag given as (EC2, S3Full).
	--- attached the policy ‘AmazonS3FullAccess’ as stated on task description. 
----Create a security group
	--- Search for security group in search bar
	--- choose the security group for EC2 in features
	--- Named the security group as "SG_Rahul"
	--- opens inbound connections to ports 80, 443 and 22 and tags added as "WebServer Sec"
----Launching EC2 instance
	--- Search for EC2 instance in search bar
	--- Select AMI as ‘Ubuntu Server 18.04 LTS (HVM)’ and instance type as ‘t2.micro’.
	--- default VPC is used.
	--- From Actions choose security and then Modify IAM role and chose "Rahul_CourseAssignment".
	--- Tag created with key ‘Name’ and value ‘Web Server’ for the EC2 instance.
	--- Then from Actions, choose Security and then Change Security Groups. Choose "SG_Rahul" from security group to the EC2 instance and launch it.
----Create S3 bucket
	---Search for S3 in search bar
	---named it as "upgrad-rahul"
	
Screenshots are attached to google drive
------------------------------------------------------------------------------------------------------------------

Task 2:	logging to EC2 amd dev the Script
----Login to EC2
	--- $ ssh -i "public key for EC2 machine" ubuntu@ec2-X-X-X-X.compute-1.amazonaws.com

----Create a file name Automation.sh version1.0
	--- move to root by "cd /"
	--- use nano editor or any editor to make script file
	--- nano Automation.sh

			# check and install the apache server if exists then fine, if not then install it.
			ServerInstall = $(apache2 -v)
			if [[ $ServerInstall == *"version: Apache"* ]]; 
			then
			  break
			else 
				sudo apt update -y
				sudo apt install apache2
			fi

			# check and start and enable the apache server
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

			
			tar -cvf /tmp/Rahul-httpd-$(date '+%d%m%Y-%H%M%S').tar /var/log/apache2/)|aws s3 cp /tmp/Rahul-httpd-$(date '+%d%m%Y-%H%M%S').tar  \s3://upgrad-rahul/rahul-httpd-$(date '+%d%m%Y-%H%M%S').tar
	--- Save it by "Ctrl +o" save file name then "ctrl +x "to exit the editor
	
	--- change mode of the file to be executable by using "chmod +x Automation.sh"
	--- then execute the script "./Automation.sh" or by using "bash Automation.sh" 
	--- Worked fine. :)


----Host Script On Github
	--- using gitbash
	--- git init
	--- git add /Automation.sh
	--- git commit -m "Automation.sh"
	--- git branch Dev
	--- git checkout Dev
	--- git push -u origin Dev
	--- create a pull request to main from dev
	--- create the tag  ‘Automation-v0.1’

------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
Task 3: Advanced Scripting 
---- Update the Automation.sh script	
	--- Edit the Automation.sh using nano editor
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
		
		# extracting size of tar file
		size=$(du -h /tmp/Rahul-httpd-$timeStamp.tar | awk '{ print $1 }')

		#check if inventory file exits and  appending with log data
		if [ -f /var/www/html/inventory.html ]
		then
		echo -e  "httpd-logs \t $timeStamp \t tar \t $size  "  >> /var/www/html/inventory.html
		else
		cat /var/www/html/inventory.html | echo -e 'Log Type \t Time Created \t \t Type \t Size' >> /var/www/html/inventory.html
		echo -e  "httpd-logs \t $timeStamp \t tar \t  $size  "  >> /var/www/html/inventory.html
		fi

---- import the script from Automation_Project from git repository 	
		git clone https://github.com/Rahmehta/Automation_Project/
		cd Automation-Project

---- Create a Cron Job
		# cron check 
			apt-get install cron
			systemctl status cron
		
	--- I created a cron job to auto execute everday at 05 in the morning as mentioned below
		00 05 * * 0-6  /Automation_Project/automation.sh
	--- start by crontab -e
	--- add the above mentioned cron tab to the file in ec2 machine. 
	--- save the crontab as /etc/cron.d/Automation
	--- then run "crontab /etc/cron.d/Automation" . this will sync the cronjob and help it to execute at desired time.
	--- in cron job five * are there where 
		---first star represents 'minute' (0-59) , 
		---second * represent hour (24 hour format), 
		---third * represent day of month (1-31)
		---fourth * represents month (1-12)
		---fifth * represents day of the week (0-7) or (sun,mon,.....)
	from left to right. followed by the command to be executed, in our case the script to be executed.
	
--------Host Script On Github
	--- using gitbash
	--- git init
	--- git add /Automation.sh
	--- git commit -m "Automation.sh"
	--- git branch Dev
	--- git checkout Dev
	--- git push -u origin Dev
	--- create a pull request to main from dev
	--- create the tag  ‘Automation-v0.2’
	
