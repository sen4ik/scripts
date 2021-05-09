#!/bin/bash
sudo apt update
sudo apt install -y xfce4 xfce4-goodies gnome-icon-theme tightvncserver

vncserver

vncserver -kill :1

VNC_X_STARTUP=~/.vnc/xstartup

mv $VNC_X_STARTUP $VNC_X_STARTUP.bak

touch $VNC_X_STARTUP

echo -e '#!/bin/bash \nxrdb $HOME/.Xresources \nstartxfce4 &' | tee $VNC_X_STARTUP /dev/null

sudo chmod +x $VNC_X_STARTUP

rm -rf /tmp/.X11-unix/X1
rm -rf /tmp/.X1-lock

vncserver -geometry 1280x1024
