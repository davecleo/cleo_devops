# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.define :harmony do |x|
      x.vm.hostname = "harmony"
      x.vm.network "private_network", virtualbox__natnet: true, type: "dhcp"
      x.vm.network "private_network", virtualbox__natnet: true, ip: "10.1.2.100"
      x.vm.hostname = "harmony"
      x.vm.box = "ubuntu/xenial64"
      x.vm.provider :virtualbox do |v|
        v.customize ['modifyvm', :id, '--nictype1', 'virtio']
        v.customize ['modifyvm', :id, '--nictype2', 'virtio']
        v.customize ['modifyvm', :id, '--nic3', 'natnetwork']
        v.customize ['modifyvm', :id, '--nat-network3', 'NatNetwork1']
        v.customize ['modifyvm', :id, '--nictype3', 'virtio']
        v.name = "harmony"
        v.memory = 4096
      end
      x.vm.provider :aws do |aws, override|
          aws.keypair_name = "vagrant"
          override.ssh.private_key_path="/Users/dbrunswick/ssh-keys/vagrant.pem"
          aws.ami = "ami-73208813"
          aws.region = "us-west-2"
          aws.instance_type = "m3.medium"
          override.ssh.username = "ubuntu"
          override.vm.box = "dummy"
          config.vm.synced_folder ".", "/vagrant", rsync__exclude: "installers"
     end
         x.vm.provision :shell, path: "bootstrap.sh"
         x.vm.provision :puppet do |puppet|
     end
  end
end
