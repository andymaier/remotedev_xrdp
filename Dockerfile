FROM rattydave/docker-ubuntu-xrdp-mate-custom:20.04

RUN sudo apt update
RUN sudo apt -y install dirmngr
RUN sudo apt-key adv --fetch-keys https://s3.eu-central-1.amazonaws.com/jetbrains-ppa/0xA6E8698A.pub.asc
RUN echo "deb http://jetbrains-ppa.s3-website.eu-central-1.amazonaws.com bionic main" | sudo tee /etc/apt/sources.list.d/jetbrains-ppa.list > /dev/null
#RUN sudo add-apt-repository -y ppa:pbek/qownnotes
#RUN sudo add-apt-repository -y ppa:fish-shell/release-3
#RUN sudo add-apt-repository -y ppa:nextcloud-devs/client
RUN sudo add-apt-repository -y ppa:eugenesan/ppa
RUN sudo add-apt-repository -y ppa:phoerious/keepassxc
RUN sudo add-apt-repository -y ppa:peek-developers/stable
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
RUN sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

RUN wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
RUN sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN sudo apt -y upgrade
RUN sudo apt -y install apt-transport-https ca-certificates curl software-properties-common docker-ce tmux zsh less mc htop git smartgithg keepassxc intellij-idea-community vim telnet nmap inetutils-ping peek xscreensaver systemd docker-compose kafkacat code maven autocutsel

RUN useradd -ms /bin/bash developer
USER developer
WORKDIR /home/developer

USER root
RUN usermod -aG sudo developer
RUN usermod -aG docker developer