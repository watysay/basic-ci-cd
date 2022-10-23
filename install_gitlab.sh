#!/bin/bash

# Install gitlab on Centos7 VM
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en.US.UTF-8"


prep_1(){
  echo "[INFO ] Running ${FUNCNAME[0]} ..."
  sudo dnf update -y
  sudo dnf install -y curl policycoreutils perl
  sudo firewall-cmd --permanent --add-service=http
  sudo firewall-cmd --permanent --add-service=https
  sudo systemctl reload firewalld

  echo "[INFO ] ${FUNCNAME[0]} was run"
  echo ""
}

prep_2(){
  echo "[INFO ] Running ${FUNCNAME[0]} ..."
  adress="https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.rpm.sh"
  # fix in order to reach adress
  nslookup packages.gitlab.com > /dev/null
  curl "${adress}" | sudo bash
  
  echo "[INFO ] ${FUNCNAME[0]} was run"
  echo ""
}

install(){
  echo "[INFO ] Running ${FUNCNAME[0]} ..."

  sudo dnf update -y
  sudo dnf install -y gitlab-ee

  echo "[INFO ] ${FUNCNAME[0]} was run"
  echo ""
}

postinstall(){
  echo "[INFO ] Running ${FUNCNAME[0]} ..."

  sudo gitlab-ctl reconfigure
  echo "Temp root password is : $(sudo grep Password /etc/gitlab/initial_root_password)"

  echo "[INFO ] ${FUNCNAME[0]} was run"
  echo ""
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
  set -euo pipefail
  main
fi


