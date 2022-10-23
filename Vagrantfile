# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vbguest.auto_update = false
  config.vbguest.no_install = true
  
  config.vm.synced_folder ".", "/vagrant"

  config.vm.define "gitlab.local" do |gl|
    gl.vm.box = "generic/rocky8"
    gl.vm.hostname = "gitlab-pipeline"
    
    gl.vm.provider "virtualbox" do |v|
      v.cpus = 2
      v.memory = 3072
    end

    gl.vm.network "private_network", ip: "192.168.56.10"
    gl.vm.network "forwarded_port", guest: 80,  host: 80
    gl.vm.network "forwarded_port", guest: 443,  host: 443

    gl.vm.provision "shell", path: "install_gitlab.sh"
  end
  
  config.vm.define "jenkins.local" do |jk|
    jk.vm.box = "generic/rocky8"
    #sb.vm.box_version = "4.1.12"
    jk.vm.hostname = "jenkins-pipeline"
    
    
    jk.vm.provider "virtualbox" do |v|
      v.cpus = 2
      v.memory = 3072
    end

    jk.vm.network "private_network", ip: "192.168.56.11"
    jk.vm.network "forwarded_port", guest: 8080,  host: 8080
    
    jk.vm.provision "shell", path: "install_jenkins.sh"
  end
end
