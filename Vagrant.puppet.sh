#!/bin/bash

### Aprovisionamiento de software ###

# Desinstalo Apache
# if [ -x "$(command -v apache2)" ]; then
  # echo 'Uninstalling apache...'
  # sudo service apache2 stop
  # sudo apt-get remove -y apache2* 
  # sudo apt autoremove -y
# fi

# Instalo git
# if ! [ -x "$(command -v git)" ]; then
  # echo 'Installing git...'
  # sudo apt-get update
  # sudo apt-get install -y git-core
# fi

# Instalo Docker
# if ! [ -x "$(command -v docker)" ]; then
  # echo 'Installing Docker...'
  # sudo apt-get update
  # sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
  # curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  # sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

  # sudo apt-get update
  # sudo apt-get install -y docker-ce docker-ce-cli docker-compose
# fi

### Configuración del entorno ###

##Genero una partición swap. Previene errores de falta de memoria
if [ ! -f "/swapdir/swapfile" ]; then
	sudo mkdir /swapdir
	cd /swapdir
	sudo dd if=/dev/zero of=/swapdir/swapfile bs=1024 count=2000000
	sudo mkswap -f  /swapdir/swapfile
	sudo chmod 600 /swapdir/swapfile
	sudo swapon swapfile
	echo "/swapdir/swapfile       none    swap    sw      0       0" | sudo tee -a /etc/fstab /etc/fstab
	sudo sysctl vm.swappiness=10
	echo vm.swappiness = 10 | sudo tee -a /etc/sysctl.conf
fi

# descargo la app del repositorio
# if [ ! -f "/var/www/html" ]; then
  # sudo mkdir /var/www/html
# fi

# if [ ! -f "/var/www/html/app-php-mysql/" ]; then
  # sudo mkdir /var/www/html
  # cd /var/www/html
  # sudo rm * -R -f
  # sudo git clone https://github.com/UTN-DevOps-2020-Grupo2/app-php-mysql.git
# fi

# Inicio docker-compose
# cd /vagrant/
# sudo docker-compose up -d

if ! [ -x "$(command -v ntpq)" ]; then
  echo 'Installing NTP...'
  sudo apt-get update
  sudo apt-get install -y ntp ntpdate
  sudo ntpdate -u 0.ubuntu.pool.ntp.org
fi

if ! [ -x "$(command -v puppetserver)" ]; then
  echo 'Installing Puppet Server...'
  wget https://apt.puppetlabs.com/puppet6-release-bionic.deb
  sudo dpkg -i puppet6-release-bionic.deb
  sudo apt-get update
  sudo apt-get install -y puppetserver
  cd /vagrant/
# Se comenta hasta que se defina si se agrega o no (dió errores en las pruebas)
#  sudo cp ./configs/puppetserver /etc/default/puppetserver
  echo 'Starting Puppet Server...'
  sudo systemctl start puppetserver
fi

if ! [ -x "$(command -v puppet)" ]; then
  echo 'Installing Puppet Agent...'
  sudo apt-get install -y puppet-agent
 
fi

cd /vagrant/
sudo cp ./configs/puppet.conf /etc/puppetlabs/puppet/puppet.conf
echo 'Starting Puppet Agent...'
sudo systemctl stop puppet
sudo systemctl start puppet
sudo systemctl enable puppet

# if ! [ -x "$(command -v service jenkins status)" ]; then
#  echo 'Installing Jenkins...'
#  wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
#  echo deb https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list
#  sudo apt-get update
#  sudo apt-get install -y jenkins
# cd /vagrant/
#  sudo cp ./configs/jenkins /etc/default/jenkins
#  echo 'Starting Jenkins...'
#  sudo systemctl start jenkins
# fi
