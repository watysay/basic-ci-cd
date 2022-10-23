Creation d'un système basique de CI/CD
---


L'installation consiste à faire tourner un Gitlab et un Jenkins
ensemble afin de réaliser des builds/tests automatiquement lors
d'un évenement sur le code versionné.



A l'aide du Vagrantfile, on peut lancer deux VMs qui se voient et
peuvent se parler.
Sur la première, on installe Gitlab via le gestionnaire de package
standard. On récupère le mot de passe root initial
sous /etc/gitlab/initial_root_password .

Sur la seconde on installe Docker puis on lance Jenkins depuis
une image docker. Ce mode de fonctionnement permettra plus tard
d'ajouter des agents docker pour Jenkins directement sur la VM.
On récupère le mot de passe root initial via la commande

docker exec jenkins-server cat /var/jenkins_home/secrets/initialAdminPassword




La configuration a travers les GUI se déroule ainsi :

GITLAB  - ajout d'un user admin  
GITLAB  - en tant que nouvel admin  
GITLAB  - ajout d'un user de dev  
GITLAB  - ajout d'un groupe de dev  
GITLAB  - ajout du user dev au group dev  
GITLAB  - en tant que user dev  
GITLAB  - creation d'un projet rattaché au group de dev, utilisation du 'sample gitlab'  
  
sur le host de vagrant :  
cloner le repo crée avec les creds du user dev.  
  
JENKINS - ajout d'un nouvel user  
JENKINS - en tant que nouvel user  
JENKINS - installer les plugins Git et Gitlab  
  
GITLAB  - creation d'un api token pour le user de dev  
  
JENKINS - ajouter le token en tant que Global creds  
JENKINS - Config System > Gitlab  
JENKINS - ajouter URL du Gitlab (en FQDN) + creds (token)  
JENKINS - tester le OK  
  
JENKINS - ajouter un Global creds = username + pass du user de dev pour Gitlab  
  
JENKINS - création d'une paire de clé ssh sur le serveur  
JENKINS - enregistrer la clé privée en tant que Global Creds  
  
GITLAB  - ajouter la clé publique sur la config du user de dev  
  
JENKINS - Créer un job Freestyle  
JENKINS - General > Github project = infos gitlab  
JENKINS - SCM > Git >   
JENKINS -   infos: url https + username/pass OU  
JENKINS -   url git@ + creds clés ssh  
JENKINS - Build Trigger > "Build when a change is pushed to Gitlab"  
JENKINS - Sauver + build + test via git commit > push gitlab  
  
JENKINS - Créer un job Pipeline  
JENKINS - General > Github project = infos gitlab  
JENKINS - SCM > Git >   
JENKINS - Build Trigger > "Build when a change is pushed to Gitlab"  
JENKINS - Pipeline > script du SCM  
JENKINS -   infos: url https + username/pass OU  
JENKINS -   url git@ + creds clés ssh  
JENKINS -   script path Jenkinsfile  
JENKINS - Sauver  
  
GITLAB  - Dépot > Settings > Integration > Jenkins  
GITLAB  -   Enabled + srv URL + project (job) name + user + mdp  
GITLAB  -   Test = appel push au Jenkins => build  
  
Test en local :  
  pull le repo de l'appli template  
  ajout d'un Jenkinsfile type Hello World  
  commit + push  
  On doit avoir le build Jenkins vers + Hello World sur la console  
  



Voies d'amélioration :
- installer les machines via Ansible
- automatiser + de parties (creation users, creation jobs ?)
- tester multibranche
- tester les merges requests
    push d'un commit => merge request => tests, si OK => proceed merge request
- tester le 'push' du status (ok/ko) de Jenkins vers Gitlab



