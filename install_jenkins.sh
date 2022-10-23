#!/bin/bash

# Install jenkins on Centos7 VM
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en.US.UTF-8"

prep_1(){

  echo "[INFO ] Running ${FUNCNAME[0]} ..."
  sudo dnf update -y
  sudo dnf install -y dnf-utils
  docker_repo="https://download.docker.com/linux/centos/docker-ce.repo"
  sudo dnf config-manager --add-repo "${docker_repo}"
  sudo dnf update -y
  echo "[INFO ] ${FUNCNAME[0]} was run"
  echo ""

}

install_docker(){

  echo "[INFO ] Running ${FUNCNAME[0]} ..."
  sudo dnf install -y docker-ce docker-compose-plugin
  echo "[INFO ] ${FUNCNAME[0]} was run"
  echo ""

}

config_docker(){

  echo "[INFO ] Running ${FUNCNAME[0]} ..."
  sudo usermod -aG docker "$USER"
  sudo systemctl start docker
  sudo systemctl enable docker
  echo "[INFO ] ${FUNCNAME[0]} was run"
  echo ""

}

create_compose(){

  echo "[INFO ] Running ${FUNCNAME[0]} ..."
  sudo mkdir -p /etc/docker/compose
  sudo chown -R root:docker /etc/docker/compose
  sudo chmod -R 775 /etc/docker/compose
  sudo mkdir -p /etc/docker/compose/jenkins
  # Create compose file 
  cat <<EOF > /tmp/compose
version: "3"

services:
  jenkins:
    image: jenkins/jenkins:lts
    container_name: jenkins-server
    privileged: true
    user: root
    restart: always
    ports:
      - 8080:8080
      - 50000:50000
    volumes:
      - ./jenkins:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
      - /usr/bin/docker:/usr/bin/docker
    extra_hosts:
      - "gitlab.example.com:192.168.56.10"

EOF

  sudo mv "/tmp/compose" /etc/docker/compose/jenkins/docker-compose.yml
  echo "[INFO ] ${FUNCNAME[0]} was run"
  echo ""

}
# 

# how to add hosts in docker container

create_compose_service(){

  echo "[INFO ] Running ${FUNCNAME[0]} ..."
  cat <<EOF > /tmp/service
[Unit]
Description=jenkins service with docker compose
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=true
WorkingDirectory=/etc/docker/compose/jenkins
ExecStart=/usr/bin/docker compose up -d
ExecStop=/usr/bin/docker compose down

[Install]
WantedBy=multi-user.target
EOF
  sudo mv "/tmp/service" "/etc/systemd/system/dc-jenkins.service"
  sudo systemctl enable dc-jenkins.service
  echo "[INFO ] ${FUNCNAME[0]} was run"
  echo ""

}

run_compose(){

  echo "[INFO ] Running ${FUNCNAME[0]} ..."
  sudo systemctl start dc-jenkins.service
  echo "[INFO ] ${FUNCNAME[0]} was run"
  echo ""

}

get_root_pass(){
  echo "[INFO ] Running ${FUNCNAME[0]} ..."
  sleep 30
  docker exec jenkins-server cat /var/jenkins_home/secrets/initialAdminPassword
  echo "[INFO ] ${FUNCNAME[0]} was run"
  echo ""
}

main(){
  # all install
  prep_1
  install_docker
  config_docker
  create_compose
  create_compose_service
  run_compose
  get_root_pass
}

if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
  # "${BASH_SOURCE[0]}" is being sourced
  echo ""
else
  set -euo pipefail
  main
fi

