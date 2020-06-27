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