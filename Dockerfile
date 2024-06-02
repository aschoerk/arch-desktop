FROM library/archlinux:latest
ENV PACMAN_OPTIONS="--noconfirm --needed"
RUN pacman $PACMAN_OPTIONS -Syyu

##############################
# basic tools
##############################
RUN pacman $PACMAN_OPTIONS -S base-devel
RUN pacman $PACMAN_OPTIONS -S git unzip ntfs-3g
RUN pacman $PACMAN_OPTIONS -S man vi gvim

# for mkfs.vfat
RUN pacman $PACMAN_OPTIONS -S dosfstools

# shell utilities
RUN pacman $PACMAN_OPTIONS -S libedit
RUN pacman $PACMAN_OPTIONS -S mlocate tmux bash-completion ctags the_silver_searcher
RUN pacman $PACMAN_OPTIONS -S doxygen curl ispell cloc svn openssh
RUN pacman $PACMAN_OPTIONS -S spice

# scripts
RUN pacman $PACMAN_OPTIONS -S python python3
RUN pacman $PACMAN_OPTIONS -S python-pip ipython r ruby

##############################
# libraries
##############################
RUN pacman $PACMAN_OPTIONS -S clang llvm clang-tools-extra
RUN pacman $PACMAN_OPTIONS -S pugixml gtest rapidjson boost

RUN pacman $PACMAN_OPTIONS -S libxslt

##############################
# apps
##############################
RUN pacman $PACMAN_OPTIONS -S docker
RUN pacman $PACMAN_OPTIONS -S emacs
# the command is remove-viewer
RUN pacman $PACMAN_OPTIONS -S tigervnc
RUN pacman $PACMAN_OPTIONS -S virt-viewer
RUN pacman $PACMAN_OPTIONS -S feh tidy mplayer discount inetutils

# compile utilities
RUN pacman $PACMAN_OPTIONS -S cmake ninja antlr4 gperftools valgrind
RUN pacman $PACMAN_OPTIONS -S jdk17-openjdk gradle maven
RUN pacman $PACMAN_OPTIONS -S clojure
# need to install at least a font so that the png file can be outputed
RUN pacman $PACMAN_OPTIONS -S graphviz ttf-dejavu
RUN pacman $PACMAN_OPTIONS -S stumpwm
RUN pacman $PACMAN_OPTIONS -S gvim


##############################
# xorg
##############################
RUN pacman $PACMAN_OPTIONS -S xterm xorg-server xorg-xinit rxvt-unicode xorg-xinput xorg-xdm xorg-xconsole
RUN pacman $PACMAN_OPTIONS -S lxde openbox x11vnc xfce4 xorg-xclock
# display managers
RUN pacman $PACMAN_OPTIONS -S lxdm xorg-xdm lightdm gdm xorg-twm

RUN useradd -m user && echo "user:user" | chpasswd
RUN echo "user ALL=(ALL) ALL" > /etc/sudoers.d/user && chmod 0440 /etc/sudoers.d/user

USER user
WORKDIR /home/user/

# copy files
COPY xinitrc .xinitrc
RUN mkdir -p ~/.vnc && echo "vncpasswd" | vncpasswd -f > ~/.vnc/passwd && chmod 0600 ~/.vnc/passwd

# use -P to publish all exposed port
# docker run -d -p 5901:5901 -p 5902:5902 lihebi/hebi-archG
# use C-] C-[ to detach, do not exit the container
# use docker attach <name> to attach
# docker exec <name> bash cannot run sudo command
EXPOSE 5901
EXPOSE 5902

CMD ["vncserver", ":1"]

