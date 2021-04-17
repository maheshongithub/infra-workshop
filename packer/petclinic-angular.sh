#!/usr/bin/env bash
sudo apt-get update
sudo apt-get install -y unzip npm apache2
echo N | sudo npm install -g @angular/cli@latest
wget https://github.com/maheshongithub/spring-petclinic-angular/archive/refs/heads/master.zip
unzip master.zip
cd spring-petclinic-angular-master
sed -i 's/localhost\:9966/api\.devops-learnings\.net/g' src/environments/environment.prod.ts
sed -i 's/http/https/g' src/environments/environment.prod.ts
echo N | npm install
ng build --prod --base-href=/petclinic/ --deploy-url=/petclinic/
sudo mv dist /var/www/html/petclinic
sudo tee -a /etc/apache2/apache2.conf > /dev/null <<EOT
<Directory /var/www/html>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
</Directory>
EOT
sudo cp ~/htaccess /var/www/html/petclinic/.htaccess
sudo chmod +x /var/www/html/petclinic/.htaccess
sudo a2enmod rewrite
sudo systemctl restart apache2
