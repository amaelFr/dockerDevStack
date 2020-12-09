ARG IMG=ubuntu:bionic

FROM ${IMG}

ENV DEBIAN_FRONTEND=noninteractive

ENV LC_ALL=C.UTF-8

ENV LANG=C.UTF-8

RUN apt update -y ; apt upgrade -y ; 

RUN apt install -y software-properties-common apt-transport-https wget curl git gnupg2 sudo

RUN wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | apt-key add -

RUN echo 'deb https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs/ vscodium main' | tee --append /etc/apt/sources.list.d/vscodium.list 

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

RUN release=$(lsb_release -cs); if [ "${release}" = "buster" ];then release="bionic"; fi && \
   add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   ${release} \
   stable"

RUN apt update

RUN apt install -y codium docker-ce-cli

RUN curl -L https://go.microsoft.com/fwlink/?LinkID=760868 -o ./code.deb

RUN apt install ./code.deb

RUN rm ./code.deb

# Other necessary lib
RUN apt install libx11-xcb1 libxcb-dri3-0 libdrm2 libgbm1 libasound2 -y

ARG UID="4000"

ARG GID="4000"

ARG USERNAME=developer

RUN groupadd -g ${GID} ${USERNAME}

RUN useradd -m -s /usr/bin/bash -u ${UID} -g ${USERNAME} ${USERNAME}

RUN echo "${USERNAME}    ALL=(ALL) ALL" >> /etc/sudoers

ARG WEB_APP="0"

ARG FRONT_JS_FRAMEWORK="0"

RUN if [ "$WEB_APP" = "1" -o "$FRONT_JS_FRAMEWORK" = "1" ]; then curl -sL https://deb.nodesource.com/setup_13.x | bash && apt-get install nodejs -y && npm install -g --force eslint; fi

RUN if [ "$FRONT_JS_FRAMEWORK" = "1" ]; then npm install -g npx @angular/cli @vue/cli --loglevel=error --force; fi

ARG TYPE_SCRIPT="0"

RUN if [ "$WEB_APP" = "1" -o "$FRONT_JS_FRAMEWORK" = "1" ] && [ "$TYPE_SCRIPT" = "1" ]; then npm install --force -g typescript; fi

ARG CONF=./conf

COPY $CONF /tmp/conf

WORKDIR /tmp/conf

RUN if [ -f /tmp/conf/packagesDef ]; then cat /tmp/conf/packagesDef | tee --append /tmp/conf/packages ; fi

RUN if [ "$WEB_APP" = "1" -o "$FRONT_JS_FRAMEWORK" = "1" ] && [ -f /tmp/conf/packagesWeb ]; then cat /tmp/conf/packagesWeb | tee --append /tmp/conf/packages ; fi

RUN if [ "$FRONT_JS_FRAMEWORK" = "1" -a -f /tmp/conf/packagesJsFram ]; then cat /tmp/conf/packagesJsFram | tee --append /tmp/conf/packages; fi

RUN if [ "$WEB_APP" = "1" -o "$FRONT_JS_FRAMEWORK" = "1" ] && [ "$TYPE_SCRIPT" = "1" ]; then cat /tmp/conf/packagesWeb | tee --append /tmp/conf/packages ; fi

ARG RUN_ROOT=""

RUN if [ "$RUN_ROOT" = "" ] && [ -f /tmp/conf/run_root.sh ]; then bash /tmp/conf/run_root.sh; else $RUN_ROOT; fi

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

USER ${USERNAME}

RUN if [ -f /tmp/conf/keybindings.json ]; then cp /tmp/conf/keybindings.json /home/${USERNAME}/.config/Code/User/; fi

# RUN mkdir -p /home/${USERNAME}/.vscode/extensions/

ARG VSCODE="codium"

RUN if [ -f /tmp/conf/packages ]; then for package in $(cat /tmp/conf/packages); do eval "${VSCODE} --install-extension $package"; if [ "$?" -ne "0" ]; then exit 1; fi; done; fi

USER root

USER ${USERNAME}

ARG RUN_USER=""

RUN if [ "$RUN_USER" = "" ] && [ -f /tmp/conf/run_user.sh ]; then bash /tmp/conf/run_user.sh; else $RUN_USER; fi

USER root

RUN rm -rf /tmp/conf

USER ${USERNAME}

ARG DEBUG_CONTAINER="debug_container"

ENV DEBUG_CONTAINER=${DEBUG_CONTAINER}

WORKDIR /home/${USERNAME}/code

ARG PATH_OPEN="./"

ENV PATH_OPEN=${PATH_OPEN}

ENV VSCODE=${VSCODE}

ENTRYPOINT eval "GTK_THEME=Adwaita:dark ${VSCODE} --wait ${PATH_OPEN}"