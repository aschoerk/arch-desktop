FROM library/archlinux:latest
ENV PACMAN_OPTIONS="--noconfirm --needed"
RUN pacman $PACMAN_OPTIONS -Syyu

RUN pacman $PACMAN_OPTIONS -S man vi gvim
RUN pacman $PACMAN_OPTIONS -S tigervnc
RUN pacman $PACMAN_OPTIONS -S sudo


##############################
# xorg
##############################
RUN pacman $PACMAN_OPTIONS -S xterm xorg-server xorg-xinit rxvt-unicode xorg-xinput xorg-xdm xorg-xconsole
RUN pacman $PACMAN_OPTIONS -S lxde openbox x11vnc xfce4 xorg-xclock

# display managers
# RUN pacman $PACMAN_OPTIONS -S lxdm xorg-xdm lightdm gdm xorg-twm


RUN echo -e "[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
RUN pacman $PACMAN_OPTIONS -Syu

RUN useradd -m user && echo "user:user" | chpasswd
RUN echo "user ALL=(ALL) ALL" > /etc/sudoers.d/user && chmod 0440 /etc/sudoers.d/user

USER user
WORKDIR /home/user/

# copy files
COPY ../xinitrc .xinitrc
RUN mkdir -p ~/.vnc && echo "vncpasswd" | vncpasswd -f > ~/.vnc/passwd && chmod 0600 ~/.vnc/passwd

# use -P to publish all exposed port
# docker run -d -p 5901:5901 -p 5902:5902 lihebi/hebi-archG
# use C-] C-[ to detach, do not exit the container
# use docker attach <name> to attach
# docker exec <name> bash cannot run sudo command
EXPOSE 5901
EXPOSE 5902

CMD ["vncserver", ":1"]
# CMD ["/usr/bin/bash"]