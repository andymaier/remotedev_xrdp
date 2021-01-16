FROM rattydave/docker-ubuntu-xrdp-mate-custom:20.04


RUN sudo apt update && apt -y install dirmngr software-properties-common
RUN sudo apt-key adv --fetch-keys https://s3.eu-central-1.amazonaws.com/jetbrains-ppa/0xA6E8698A.pub.asc
RUN echo "deb http://jetbrains-ppa.s3-website.eu-central-1.amazonaws.com bionic main" | sudo tee /etc/apt/sources.list.d/jetbrains-ppa.list > /dev/null
RUN sudo add-apt-repository -y ppa:pbek/qownnotes
RUN sudo add-apt-repository -y ppa:fish-shell/release-3
RUN sudo add-apt-repository -y ppa:nextcloud-devs/client
RUN sudo add-apt-repository -y ppa:eugenesan/ppa
RUN sudo add-apt-repository -y ppa:phoerious/keepassxc
RUN sudo add-apt-repository -y ppa:peek-developers/stable
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
RUN sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

# vscode
RUN wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
RUN sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"

RUN sudo sed -i 's|http://tw.|http://de.|g' /etc/apt/sources.list

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN sudo apt -y upgrade
RUN sudo apt -y install apt-transport-https ca-certificates curl qownnotes docker-ce tmux zsh less mc htop git smartgithg keepassxc intellij-idea-community vim telnet nmap inetutils-ping peek xscreensaver docker-compose kafkacat code maven

#chrome
ARG CHROME_VERSION="google-chrome-stable"
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update -qqy \
  && apt-get -qqy install \
    ${CHROME_VERSION:-google-chrome-stable} \
  && rm /etc/apt/sources.list.d/google-chrome.list \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# wine 
ADD https://dl.winehq.org/wine-builds/winehq.key /Release.key

RUN echo "deb http://dl.winehq.org/wine-builds/ubuntu/ xenial main" >> /etc/apt/sources.list && \
	apt-key add Release.key && \
	dpkg --add-architecture i386 && \
	apt-get update && \
	apt-get install -y --install-recommends winehq-devel \
	&& rm -rf /var/lib/apt/lists/* /Release.key

RUN groupadd -g 1000 wine \
	&& useradd -g wine -u 1000 wine \
	&& mkdir -p /home/wine/.wine && chown -R wine:wine /home/wine

# Run MetaTrader as non privileged user.
USER wine
ENV WINEARCH win32