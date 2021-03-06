# Awesome config Makefile
PWD:=$(shell pwd)

gtk_theme:
	cd /tmp &&\
	git clone git@github.com:vinceliuice/vimix-gtk-themes.git &&\
	cd vimix-gtk-themes && \
	./Install

gtk_icon:
	cd /tmp &&\
	git clone git@github.com:vinceliuice/vimix-icon-theme.git &&\
	cd vimix-icon-theme && \
	./install.sh

git_config:
	if ! [ -f $HOME/.config/gtkrc-2.0 ] \
    then \
        mkdir $HOME/.config/gtk-2.0  && \
        echo -e "* $HOME/.config/gtk2.0 directory  created successfully" \
        { \
            echo -e "[Settings]"  \
            echo -e "gtk-theme-name = vimix-light-beryl" \
            echo -e "gtk-icon-theme-name = Paper-Vimix" \
            echo -e "gtk-sound-theme-name = ubuntu" \
            echo -e "gtk-icon-sizes = panel-menu-bar=24,24" \
        } > $HOME/.config/gtk-2.0/settings.ini && \
        chown $USER: $HOME/.gtkrc-2.0 && \
        echo -e "* gtkrc-2.0 config file created successfully" \
    else \
        echo -e "* gtkrc-2.0 directory file already exists" \
    fi \
    if [ ! -d $HOME/.config/gtk-3.0 ] \
    then \
        mkdir $HOME/.config/gtk-3.0  && \
        echo -e "* $HOME/.config/gtk3.0 directory  created successfully" \
        { \
            echo -e "[Settings]" \
            echo -e "gtk-theme-name = vimix-light-beryl" \
            echo -e "gtk-icon-theme-name = Paper-Vimix" \
            echo -e "gtk-sound-theme-name = ubuntu" \
            echo -e "gtk-icon-sizes = panel-menu-bar=24,24" \
        } > $HOME/.config/gtk-3.0/settings.ini && \
        chown $USER: $HOME/.config/gtkrc-3.0 && \
        echo -e "* settings.ini config file created successfully" \
    else \
        echo -e "* gtkr-3.0 directory  already exists" \
    fi


apt_deps:
	sudo apt-get update && install -y compton xsel python-pip gtk2-engines-murrine gtk2-engines-pixbuf

pip_deps: apt-deps
	pip installl powerline-shell

start_xephyr:
	if ! pgrep Xephyr; then \
		Xephyr -ac -br -noreset -screen 1200x800 :2 & \
	fi

stop_xephyr:
	if ! pgrep Xephyr; then \
		echo "Xephyr server was not running" \
	else \
		kill -9 $(pgrep Xephyr); \
	fi

awesome_session: stop_xephyr start_xephyr
	 DISPLAY=:2.0 awesome -c $(PWD)/rc.lua


