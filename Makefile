# Awesome config Makefile
PWD:=$(shell pwd)

GTK_THEMES := vinceliuice/vimix-gtk-themes vinceliuice/vimix-icon-theme
LUA_PAM_GIT := RMTT/lua-pam
FONT_GIT := powerline/fonts

define install_gtk
	$(foreach gtk,$(GTK_THEMES),git clone git@github.com:$(gtk).git && cd $(shell basename $(gtk)) && ./install.sh -a;)
endef

define install_font
	$(foreach font,$(FONT_GIT),git clone git@github.com:$(font).git && cd $(shell basename $(font)) && ./install.sh;)
endef

define build_lua_pam
	git clone git@github.com:$(LUA_PAM_GIT).git && \
	cd $(shell basename $(LUA_PAM_GIT)) && \
	sed -i 's#14)#14)\n\ninclude_directories(/usr/include/lua5.3)#; s# lua # lua5.3 #;' CMakeLists.txt && \
	cmake . -B build && \
	make -C build && \
	sudo -S install -Dm 755 build/liblua_pam.so -t /usr/lib/lua-pam/
endef

font_setup:
	cd /tmp && \
	$(call install_font)

gtk_setup:
	cd /tmp &&\
	$(call install_gtk)

gtk_config:
	lxappearance

lua_pam:
	cd /tmp && \
	$(call build_lua_pam)

xmodmap:
	echo "keycode 108 = Multi_key Alt_R Meta_R Alt_R Meta_R" > $(HOME)/.Xmodmap

apt_deps:
	sudo -S apt-get update && \
	sudo -S apt-get install -y \
	compton xsel xclip python3-pip gtk2-engines-murrine gtk2-engines-pixbuf light redshift \
	redshift-gtk maim rofi slick-greeter lxappearance playerctl inotify-tools ttfautohint fontforge liblua5.3-dev libpam0g-dev \
	lua-sec lua-socket lua-http lua-json lua-cjson

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


