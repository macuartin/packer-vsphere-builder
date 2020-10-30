# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "hardened" do |hardened|

    # OS Configuration
    hardened.vm.box = "centos/7"

    #Network configuraions
    hardened.vm.network "public_network", ip: "192.168.0.100"

    # Hardware configurations
      hardened.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = "1024"
    end

    config.vm.provision "ansible" do |ansible|
      ansible.playbook = "playbooks/cis.yml"
      ansible.raw_arguments  = ["--tags=patch", "--check"]
    end

  end

end
