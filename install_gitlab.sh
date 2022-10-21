#!/bin/bash

# Install gitlab on Centos7 VM
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en.US.UTF-8"

prep_1(){
  sudo dnf install -y curl policycoreutils perl
  sudo firewall-cmd --permanent --add-service=http
  sudo firewall-cmd --permanent --add-service=https
  sudo systemctl reload firewalld
}

prep_2(){
  adress="https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.rpm.sh"
  curl ${adress} | sudo bash
}

install(){
  sudo dnf install -y gitlab-ee
}

postinstall(){
  sudo gitlab-ctl reconfigure
  echo "Temp root password is : $(sudo grep Password /etc/gitlab/initial_root_password)"
}

main(){
  prep_1
  prep_2
  install
  postinstall
}

if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
  # "${BASH_SOURCE[0]}" is being sourced
  echo ""
else
  main
fi


