#!/bin/bash

# Install jenkins on Centos7 VM
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en.US.UTF-8"

prep_1(){
  sudo dnf install -y dnf-utils
  docker_repo="https://download.docker.com/linux/centos/docker-ce.repo"
  sudo dnf config-manager --add-repo "${docker_repo}"
  sudo dnf update -y
}

install_docker(){
  sudo dnf install -y docker-ce docker-compose-plugin
}

config_docker(){
  sudo usermod -aG docker "$USER"
  sudo systemctl start docker
  sudo systemctl enable docker
}

create_compose(){
  sudo mkdir -p /etc/docker/compose
  sudo chown -R root:docker /etc/docker/compose
  sudo chmod -R 775 /etc/docker/compose
  mkdir -p /etc/docker/compose/jenkins
  cd /etc/docker/compose/jenkins 
  # Create compose file 
  cat <<EOF > docker-compose.yml
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
}
# 

# how to add hosts in docker container

create_compose_service(){

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
}

run_compose(){
  echo ""
}


main(){
  # all install
  prep_1
  install_docker
  config_docker
  create_compose
  run_compose
}

if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
  # "${BASH_SOURCE[0]}" is being sourced
  echo ""
else
  main
fi


# get the admin pass
#docker exec jenkins-server cat /var/jenkins_home/secrets/initialAdminPassword
# creation du premier admin user
# creation d'un user de dev
## ajout d'un agent
# plugin docker
