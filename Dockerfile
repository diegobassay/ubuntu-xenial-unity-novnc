FROM ubuntu:16.04
LABEL maintainer="diegobassay@gmail.com"

ENV DEBIAN_FRONTEND noninteractive
ENV USER budi
ENV HOME /home/$USER
RUN chmod u+s /usr/bin/passwd
RUN useradd -ms /bin/bash $USER
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

RUN echo '/usr/lib/gnome-session/gnome-session-binary --session=ubuntu &\n\
/usr/lib/x86_64-linux-gnu/unity/unity-panel-service &\n\
/usr/lib/unity-settings-daemon/unity-settings-daemon &\n\
\n\
for indicator in /usr/lib/x86_64-linux-gnu/indicator-*; do\n\
basename=`basename ${indicator}`\n\
dirname=`dirname ${indicator}`\n\
service=${dirname}/${basename}/${basename}-service\n\
${service} &\n\
done\n\
unity\n\
' >$HOME/.xsession

RUN echo '[program:vncserver]\n\
command=vncserver -geometry 1366x768 :1\n\
user=budi\n\
\n\
[program:novnc]\n\
command=/home/budi/novnc/utils/launch.sh --vnc localhost:5901\n\
user=budi\n\
stdout_logfile=/var/log/novnc.log\n\
redirect_stderr=true\n\
' >/etc/supervisor/conf.d/supervisor.conf

RUN echo '#!/bin/bash\n\
[ -f $HOME/.vnc/passwd ] && vncserver -kill :1 && rm -rf $HOME/.vnc && rm -rf /tmp/.X1*\n\
PASSWORD=``\n\
su $USER -c "mkdir $HOME/.vnc && echo $PASSWORD | vncpasswd -f > $HOME/.vnc/passwd && chmod 600 $HOME/.vnc/passwd && touch $HOME/.Xresources"\n\
chown -R $USER:$USER $HOME\n\
[ ! -z "$SUDO" ] && adduser $USER sudo\n\
/usr/bin/supervisord -n\n\
' >$HOME/startup.sh

RUN chmod +x $HOME/startup.sh

CMD ["/bin/bash", "-c", "$HOME/startup.sh"]