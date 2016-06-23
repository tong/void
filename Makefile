
## Void

PROJECT=void
#INSTALL_DIR="${HOME}/.themes"
SRC=res/style/*
HX=haxe -lib om.core -dce full -cp src

all: build

build: \
	build/atom \
	build/chrome/scrollbar \
	build/chrome/theme \
	build/dox \
	build/font \
	build/gtk-3.0 \
	build/wallpaper \
	build/web \
	build/zsh \
	build/index.theme

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

build/chrome/scrollbar/dim.css: $(SRC) res/chrome/scrollbar/*
	lessc res/chrome/scrollbar/dim.less $@
build/chrome/scrollbar/scrollbar.css: $(SRC) res/chrome/scrollbar/*
	lessc res/chrome/scrollbar/scrollbar.less $@

build/chrome/scrollbar: build/chrome/scrollbar/dim.css build/chrome/scrollbar/scrollbar.css
	cp res/chrome/scrollbar/manifest.json $@
	cp res/chrome/scrollbar/content.js $@

build/chrome/theme:
	mkdir -p $@
	cp -r res/chrome/theme/images $@
	cp res/chrome/theme/manifest.json $@

build/dox: $(SRC) res/dox/*
	mkdir -p $@
	${HX} -js $@/assets/app.js -main void.dox.App
	cp -r res/dox/resources $@
	cp -r res/dox/templates $@
	cp res/dox/config.json $@

build/font:
	mkdir -p $@
	cp res/font/* $@

build/gtk-2.0/gtk.css: $(SRC) res/gtk-2/*
	lessc res/gtk-2/gtk.less $@

build/gtk-2.0: build/gtk-2.0/gtk.css

build/gtk-3.0/gtk-dark.css: $(SRC) res/gtk-3/*
	lessc res/gtk-3/gtk-dark.less $@

build/gtk-3.0/gtk.css: $(SRC) res/gtk-3/*
	lessc res/gtk-3/gtk.less $@

build/gtk-3.0: \
	build/gtk-3.0/gtk.css \
	build/gtk-3.0/gtk-dark.css

build/index.theme:
	cp res/index.theme $@

build/wallpaper:
	mkdir -p build/wallpaper
	cp res/image/wallpaper/* $@

build/web:
	mkdir -p $@
	lessc res/web/web.less $@/void.css
	cp res/web/web.js $@/void.js
	cp res/web/index.html $@

build/zsh/prompt: src/void/zsh/*
	$(HX) -cpp build/zsh/src -main void.zsh.Prompt
	mv build/zsh/src/Prompt $@

build/zsh: build/zsh/prompt

install:
	cp -r build ${HOME}/.themes/Void
	ln -s ${HOME}/.themes/Void/atom/syntax ${HOME}/.atom/packages/void-syntax
	ln -s ${HOME}/.themes/Void/atom/ui ${HOME}/.atom/packages/void-ui

uninstall:
	rm -rf ${HOME}/.themes/Void

clean:
	rm -rf build

.PHONY: all build install uninstall clean
