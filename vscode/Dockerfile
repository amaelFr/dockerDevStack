ARG IMG=ubuntu:bionic

FROM ${IMG}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update -y ; apt upgrade -y ; 

RUN apt install -y software-properties-common apt-transport-https curl wget git

RUN wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | apt-key add - 

RUN echo 'deb https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/repos/debs/ vscodium main' >> /etc/apt/sources.list.d/vscodium.list

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

RUN apt update

RUN apt install -y codium docker-ce-cli

RUN apt-get install libx11-xcb1 libasound2 -y #lib to visuel

ARG UID="4000"

ARG GID="4000"

ARG USERNAME=developer

RUN groupadd -g ${GID} ${USERNAME}

RUN useradd -m ${USERNAME} -u ${UID} -g ${USERNAME}

WORKDIR /home/${USERNAME}/code

ARG WEB_APP="0"

ARG FRONT_JS_FRAMEWORK="0"

RUN if [ "$WEB_APP" = "1" -o "$FRONT_JS_FRAMEWORK" = "1" ]; then curl -sL https://deb.nodesource.com/setup_13.x | bash && apt-get install nodejs -y && npm install -g --force eslint; fi

RUN if [ "$FRONT_JS_FRAMEWORK" = "1" ]; then npm install -g npx @angular/cli @vue/cli --loglevel=error --force; fi

ARG TYPE_SCRIPT="0"

RUN if [ "$WEB_APP" = "1" -o "$FRONT_JS_FRAMEWORK" = "1" ] && [ "$TYPE_SCRIPT" = "1" ]; then npm install --force -g typescript; fi

ARG CONF=conf

COPY $CONF /tmp/conf

RUN if [ -f /tmp/conf/packagesDef ]; then cat /tmp/conf/packagesDef >> /tmp/conf/packages ; fi

RUN if [ "$WEB_APP" = "1" -o "$FRONT_JS_FRAMEWORK" = "1" ] && [ -f /tmp/conf/packagesWeb ]; then cat /tmp/conf/packagesWeb >> /tmp/conf/packages ; fi

RUN if [ "$FRONT_JS_FRAMEWORK" = "1" -a -f /tmp/conf/packagesJsFram ]; then cat /tmp/conf/packagesJsFram >> /tmp/conf/packages; fi

RUN if [ "$WEB_APP" = "1" -o "$FRONT_JS_FRAMEWORK" = "1" ] && [ "$TYPE_SCRIPT" = "1" ]; then cat /tmp/conf/packagesWeb >> /tmp/conf/packages ; fi

USER ${USERNAME}

RUN if [ -f /tmp/conf/keybindings.json ]; then cp /tmp/conf/keybindings.json /home/${USERNAME}/.config/Code/User/; fi

RUN if [ -f /tmp/conf/packages ]; then while read package; do codium --install-extension $package; done </tmp/conf/packages; fi

USER root

RUN rm -rf /tmp/conf

ARG INSTALL_ROOT=""

RUN eval $INSTALL_ROOT

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

USER ${USERNAME}

ARG INSTALL_USER=

RUN eval $INSTALL_USER

ARG PATH_OPEN=.

ENV PATH_OPEN=$PATH_OPEN

ARG DEBUG_CONTAINER="debug_container"

ENV DEBUG_CONTAINER=${DEBUG_CONTAINER}

ENTRYPOINT codium --wait ${PATH_OPEN}
