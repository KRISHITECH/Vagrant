#-*- coding: utf-8 -*-
#!/usr/bin/env bash
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password password'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password password'

sudo aptitude update
sudo aptitude -y -q=2 upgrade
sudo aptitude install -y -q=2 build-essential git cvs git-core libcurl3 \
libcurl3-gnutls libcurl4-openssl-dev mysql-server mysql-client libmysqlclient-dev \
libzmq3 libzmq3-dev

echo "--- INSTALLING MYSQL ---"
# # https://github.com/AlexDisler/mysql-vagrant/blob/master/install.sh
# sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
# sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
# sed -i "s/^bind-address/#bind-address/" /etc/mysql/my.cnf
sudo service mysql enable
# sudo /usr/bin/mysqladmin -u root --password password password 'password' #i heard you like passwords
mysql -u root -ppassword -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION; FLUSH PRIVILEGES;"
mysql -u root -ppassword -e "CREATE DATABASE farmbot_api_dev;"
sudo service mysql restart

echo "--- INSTALLING RVM ---"
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable --quiet-curl --ruby=2.3.1

echo "--- INSTALLING RUBY 2.3.1 ---"
sudo apt-get install -f
source /home/vagrant/.rvm/scripts/rvm
rvm reload
rvm use 2.3.1
gem install bundler

echo "--- INSTALLING ASDF ---"
sudo mkdir /usr/share/asdf
sudo chmod -R 777 /usr/share/asdf
git clone https://github.com/asdf-vm/asdf.git /usr/share/asdf --branch v0.1.0
source /usr/share/asdf/asdf.sh

echo "--- INSTALLING NODEJS ---"
asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs 6.5.0
asdf global nodejs 6.5.0
npm install esprima -g

echo "OKAY - GOING TO INSTALL OUR OWN THINGS NOW"

echo "--- INSTALLING WEB API ---"
cd /vagrant
git clone https://github.com/FarmBot/Farmbot-Web-API farmbot-web-app
cd farmbot-web-app
gem install bundler
bundle install
cp config/database.example.yml config/database.yml
ruby ../scripts/db-provision.rb
RAILS_ENV=development rake db:setup
RAILS_ENV=development rake db:migrate

echo "--- INSTALLING MQTT ---"
cd /vagrant
git clone https://github.com/FarmBot/mqtt-gateway.git
cd mqtt-gateway
echo "Npm installing"
npm install --no-bin-links

echo "--- INSTALLING WEB FRONTEND ---"
cd /vagrant
git clone https://github.com/FarmBot/farmbot-web-frontend.git
cd farmbot-web-frontend
echo "Npm installing"
npm install
