# -*- mode: ruby -*-
# vi: set ft=ruby :VAGRANTFILE_API_VERSION = "2"

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure("2") do |config|
  # Use Ubuntu 14.04 Trusty Tahr 64-bit as our operating system
  config.vm.box = "ubuntu/trusty64"
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"

  # Configurate the virtual machine to use 4GB of RAM
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "4096"]
  end

  # Forward the Rails server default port to the host
  config.vm.network "forwarded_port", guest: 3000, host: 3000
  config.vm.network "forwarded_port", guest: 3002, host: 3002
  config.vm.network "forwarded_port", guest: 80, host: 3002
  config.vm.network "forwarded_port", guest: 1883, host: 1883
  config.vm.network "forwarded_port", guest: 9200, host: 9201

  config.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777", "fmode=666"]

  config.vm.provision :shell, path: "scripts/bootstrap.sh", privileged: false

  config.trigger.after :up do
    run_remote "bash /vagrant/scripts/startup.sh"
  end
end
