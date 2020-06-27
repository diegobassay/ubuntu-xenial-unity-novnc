FROM ubuntu:16.04
LABEL maintainer="diegobassay@gmail.com"

ENV DEBIAN_FRONTEND noninteractive
ENV USER budi
ENV HOME /home/$USER
RUN adduser $USER sudo --disabled-password