#!/bin/bash  
 

 #######################################
 # FIRST YOU NEED TO RUN THESE 2 CMD:
 # cd /home/admin/Downloads
 # sudo chmod +x LAMP-WP-Setup.sh
 # sudo ./LAMP-WP-Setup.sh

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
   
 # Ask for password   
 read -p 'Open this file because you need key for vpn and/or enter code in nano screens. To continue please enter your [PASSWORD]: ' db_root_password  
 echo  

 # Update system  
 sudo apt update && sudo apt upgrade -y

 # Check for updates errors  
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
 sudo service apache2 restart
 sudo apt-get install samba samba-common-bin -y

 sudo mkdir /home/admin/shared
 sudo chmod 777 /home/admin/shared

 sudo nano /etc/samba/smb.conf

 
 ##############################################################
 ############
 ############ -------->>>>>       SAMBA code at the very bottom. [shared] has to be green
 ############
 ##############################################################
 #[shared]
 # path = /home/admin/shared
 # available = yes
 # browsable = yes
 # public = yes
 # writable = yes


 sudo smbpasswd -a admin

 sudo service smbd restart
   
 ## Install PHP  
 sudo service apache2 restart
 apt-get install php libapache2-mod-php php-mysql -y
 
 ## Create info.php
 sudo rm /var/www/html/*  
 echo '<?php phpinfo(); ?>' | sudo tee -a /var/www/html/index.php > /dev/null

 ## Install Firefox 
 sudo apt install firefox-esr

   
 ## Install MySQL database server 
 sudo service apache2 restart 
 export DEBIAN_FRONTEND="noninteractive"  
 debconf-set-selections <<< "mysql-server mysql-server/root_password password $db_root_password"  
 debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $db_root_password"  
 apt-get install mariadb-server -y  
   
 # Enabling Mod Rewrite  
 sudo a2enmod rewrite  
 sudo php5enmod mcrypt  
   
 ## Install PhpMyAdmin  
 sudo service apache2 restart
 sudo apt-get install phpmyadmin -y  
   
 ## Configure PhpMyAdmin  
 echo 'Include /etc/phpmyadmin/apache.conf' >> /etc/apache2/apache2.conf  
   
 # Set Permissions  

   
 # Restart Apache  
 sudo service apache2 restart
 
 ## Install MySQL Secure Installation
 sudo mysql_secure_installation

 # Install WordPress
 sudo service apache2 restart
 sudo mkdir /var/www/html/WP
 cd /var/www/html/WP
 sudo wget http://wordpress.org/latest.tar.gz
 sudo tar xzf latest.tar.gz
 sudo mv wordpress/* .
 sudo rm -rf wordpress latest.tar.gz
 sudo chown -R www-data: .

   # Ask for waiting for deal with VPN sitution  
 read -p 'How many seconds do you need to visit http://localhost/WP and finish setup there ? (0-999)  ' waiting2  
 echo
 
 # Waiting to connect ... 
 sleep $waiting2

 ##################################################
 # Database Name:      wordpress
 # User Name:          admin
 # Password:           pi
 # Database Host:      localhost
 # Table Prefix:       wp_
 
 sudo a2enmod rewrite
 sudo nano /etc/apache2/sites-available/000-default.conf

 ###################################################
 # Repleace below with first line on your code.
 #
 # <VirtualHost *:80>
 #   <Directory "/var/www/html/WP">
 #       AllowOverride All
 #   </Directory>

 sudo service apache2 restart



 # Show current permissions
 ls -al

 # Set Permissions 
 sudo chown -R admin:www-data /var/www/html/ 
 sudo chmod -R 775 /var/www/html/ 
 ls -al  

 # Open MySQL to add user
 sudo service apache2 restart
 sudo mysql --user=root --password

 ##############################################################
 ############
 ############ -------->>>>>       MySQL data needed to be entered manually:  
 ############
 ##############################################################

 #	create user admin@localhost identified by 'pi';
 #	grant all privileges on *.* to admin@localhost;
 #	create database wordpress;
 #	USE wordpress;
 #	GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' IDENTIFIED BY 'pi';
 #	FLUSH PRIVILEGES; 
 #	exit;




 #################################################
 # sudo chmod +x setup.sh
 # sudo ./setup.sh
