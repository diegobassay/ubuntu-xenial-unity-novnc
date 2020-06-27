FROM ubuntu:16.04
LABEL maintainer="diegobassay@gmail.com"

ENV DEBIAN_FRONTEND noninteractive
ENV USER budi
ENV HOME /home/$USER
RUN adduser $USER
RUN echo 'budi:budi' | chpasswd
RUN usermod -aG sudo budi && whoami

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ubuntu-desktop \
        unity-lens-applications \
        gnome-panel \
        metacity \
        nautilus \
        lib32gcc1 \
        lib32stdc++6 \
        libpango1.0-0 \
        libpq5 \
        gedit \
        xterm \
        sudo

RUN add-apt-repository ppa:ubuntu-mozilla-security/ppa

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        supervisor \
        net-tools \
        curl \
        nodejs \
        npm \
        git \
        gdebi \
        xdg-utils \
        libtasn1-3-bin \
        libglu1-mesa \
        firefox \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get install -f

WORKDIR $HOME

ADD https://bintray.com/tigervnc/stable/download_file?file_path=tigervnc-1.10.1.x86_64.tar.gz $HOME/tigervnc/tigervnc.tar.gz
RUN tar xmzf $HOME/tigervnc/tigervnc.tar.gz -C $HOME/tigervnc/ && rm $HOME/tigervnc/tigervnc.tar.gz
RUN cp -R $HOME/tigervnc/tigervnc-1.10.1.x86_64/* / && rm -rf $HOME/tigervnc/

RUN git clone https://github.com/novnc/noVNC.git $HOME/novnc
RUN cp $HOME/novnc/vnc.html $HOME/novnc/index.html

RUN git clone https://github.com/kanaka/websockify $HOME/novnc/utils/websockify        