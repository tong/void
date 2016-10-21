##
## Void
##
#### DEBUG=1 : Enable debug options
##

PROJECT=void
DEBUG=0
NUM_BUILD_THREADS=2
#INSTALL_DIR="${HOME}/.themes"
SRC_STYLE=res/style/*
HX=haxe -lib om.core -cp src -dce full

ifeq ($(DEBUG),1)
	HX+=-debug
else
	HX+=--no-traces
endif

all: build

build: \
	build/atom \
	build/chrome/scrollbar \
	build/chrome/theme \
	build/cursor \
	build/dox \
	build/font \
	build/gtk-3.0 \
	build/wallpaper \
	build/web \
	build/zsh \
	build/index.theme

################################################################################

##### ATOM

build/atom/syntax:
	mkdir -p build/atom
	mkdir -p $@
	cp -r res/atom/syntax/styles $@
	cp res/atom/syntax/index.less $@
	cp res/atom/syntax/package.json $@
	cp res/style/colors.less $@/styles

build/atom/ui:
	mkdir -p build/atom
	mkdir -p $@
	cp -r res/atom/ui/styles $@
	cp res/atom/ui/index.less $@
	cp res/atom/ui/package.json $@
	cp res/style/colors.less $@/styles

build/atom: \
	build/atom/syntax \
	build/atom/ui

##### CHROME

build/chrome/mod/dim.css: $(SRC_STYLE) res/chrome/mod/*
	lessc res/chrome/mod/dim.less $@
build/chrome/mod/scrollbar.css: $(SRC_STYLE) res/chrome/mod/*
	lessc res/chrome/mod/scrollbar.less $@
build/chrome/mod: build/chrome/mod/dim.css build/chrome/mod/scrollbar.css
	cp res/chrome/mod/manifest.json $@
	cp res/chrome/mod/content.js $@

build/chrome/theme:
	mkdir -p $@
	cp -r res/chrome/theme/images $@
	cp res/chrome/theme/manifest.json $@

##### CURSOR

build/cursor:
	mkdir -p $@
	python tool/renderpngs.py res/cursor/cursors.svg --number-of-renderers $(NUM_BUILD_THREADS) --anicursorgen
	mv pngs $@
	cp res/cursor/*.theme $@

##### DOX

build/dox: $(SRC_STYLE) res/dox/*
	mkdir -p $@
	${HX} -js $@/assets/app.js -main void.dox.App
	cp -r res/dox/resources $@
	cp -r res/dox/templates $@
	cp res/dox/config.json $@

##### FONTS

build/font:
	mkdir -p $@
	cp res/font/* $@

##### GTK

build/gtk-2.0/gtk.css: $(SRC_STYLE) res/gtk-2/*
	lessc res/gtk-2/gtk.less $@

build/gtk-2.0: build/gtk-2.0/gtk.css

build/gtk-3.0/gtk-dark.css: $(SRC_STYLE) res/gtk-3/*
	lessc res/gtk-3/gtk-dark.less $@

build/gtk-3.0/gtk.css: $(SRC_STYLE) res/gtk-3/*
	lessc res/gtk-3/gtk.less $@

build/gtk-3.0: \
	build/gtk-3.0/gtk.css \
	build/gtk-3.0/gtk-dark.css

#build/i3: res/i3/*
#	cp -r res/i3 build/i3

build/index.theme:
	cp res/index.theme $@


##### WALLPAPERS

build/wallpaper:
	mkdir -p build/wallpaper
	cp res/image/wallpaper/* $@

##### WEB

build/web/void.css: res/web/*
	lessc res/web/void.less $@

build/web/void.js: res/web/*
	$(HX) -js $@ -main void.web.Components

build/web/void.html: res/web/*
	cp res/web/void.html $@

build/web: build/web/void.css build/web/void.js build/web/void.html
	cp res/web/example.html $@/example.html
	cp res/web/components.html $@/components.html

build/zsh/prompt: src/void/zsh/*.hx
	$(HX) -cpp build/zsh/src -main void.zsh.Prompt
	mv build/zsh/src/Prompt $@


##### ZSH

build/zsh: build/zsh/prompt

################################################################################

install:
	cp -r build ${HOME}/.themes/Void
	ln -s ${HOME}/.themes/Void/atom/syntax ${HOME}/.atom/packages/void-syntax
	ln -s ${HOME}/.themes/Void/atom/ui ${HOME}/.atom/packages/void-ui

uninstall:
	rm -rf ${HOME}/.themes/Void

clean:
	rm -rf build

.PHONY: all build install uninstall clean
