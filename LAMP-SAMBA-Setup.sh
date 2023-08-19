#!/bin/bash  
 

 #######################################
 # FIRST YOU NEED TO RUN THESE 2 CMD:
 # cd /home/admin/Downloads
 # sudo chmod +x setup.sh
 # sudo ./setup.sh

 # YOU WILL NEED ACTIVATION CODE AS WELL AS ENTERING PASSWORD AND STUFF
 # AND YOU HAVE TO ENTER OR EDIT COFIG FILES WHILE THERE ARE OPEN FOR
 # YOU.

 # HAVE FUN AND ENJOY THIS HAPPEND AFTER AT LEAST 40+ TIMES OF LAMP
 # INSTALLATION TO FIGURE THIS OUT.

 # HAPPY PI
   
 #######################################  
 # Bash script to install an LAMP stack in ubuntu  
 # Authors: Openai Chat and Amir ;*
   
 # Check if running as root  
 if [ "$(id -u)" != "0" ]; then  
   echo "This script must be run as root" 1>&2  
   exit 1  
 fi  
   
 # Ask value for mysql root password   
 read -p 'Open this file because you need key for vpn and/or enter code in nano screens. To continue please enter your [PASSWORD]: ' db_root_password  
 echo  


  
 # Update system  
 sudo apt update -y

 # Check if running as root  
 if [ $? -ne 0 ]; then  
   echo "ERROR: Failed to upade the system." 
   exit 1  
 fi
   

 ## Install APache  
 sudo apt-get install apache2 -y

 # Set Permissions 
 sudo chown -R admin:www-data /var/www/html/
 sudo chmod -R 770 /var/www/html/  

 ## Insall Samba
 sudo apt-get install samba samba-common-bin -y

 sudo mkdir /home/admin/shared
 sudo chmod 777 /home/admin/shared

 sudo nano /etc/samba/smb.conf

 ################# ENTER this #############
 #[shared]
 # path = /home/admin/shared
 # available = yes
 # browsable = yes
 # public = yes
 # writable = yes

 sudo service smbd restart
   
 ## Install PHP  
 apt-get install php libapache2-mod-php php-mysql -y
 
 ## Create info.php
 sudo rm /var/www/html/*  
 echo '<?php phpinfo(); ?>' | sudo tee -a /var/www/html/index.php > /dev/null
   
 ## Install MySQL database server  
 export DEBIAN_FRONTEND="noninteractive"  
 debconf-set-selections <<< "mysql-server mysql-server/root_password password $db_root_password"  
 debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $db_root_password"  
 apt-get install mariadb-server -y  
   
 # Enabling Mod Rewrite  
 sudo a2enmod rewrite  
 sudo php5enmod mcrypt  
   
 ## Install PhpMyAdmin  
 sudo apt-get install phpmyadmin -y  
   
 ## Configure PhpMyAdmin  
 echo 'Include /etc/phpmyadmin/apache.conf' >> /etc/apache2/apache2.conf  
   
 # Set Permissions  

   
 # Restart Apache  
 sudo service apache2 restart
 
 ## Install MySQL Secure Installation
 sudo mysql_secure_installation

 # Show current permissions
 ls -al

 # Set Permissions 
 sudo chown -R admin:www-data /var/www/html/ 
 sudo chmod -R 770 /var/www/html/ 
 ls -al  

 # Open MySQL to add user
 sudo mysql --user=root --password

 #	create user admin@localhost identified by 'pi';
 #	grant all privileges on *.* to admin@localhost;
 #	create database wordpress;
 #	GRANT ALL PRIVILEGES ON wordpress.* TO 'admin'@'localhost' IDENTIFIED BY 'pi';
 #	FLUSH PRIVILEGES;




 #################################################
 # sudo chmod +x setup.sh
 # sudo ./setup.sh
