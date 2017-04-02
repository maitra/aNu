include src/config.txt

ifeq ($(LDFLAGS),)
	LDFLAGS = -Wl,--as-needed
endif

ifeq ($(LDLIBS),)
	LDLIBS = -L/usr/local/lib $(LIBS_VTE_L) -lglib-2.0 -lgobject-2.0 $(LIBS_VTE) -lpango-1.0
endif

CFLAGS += $(OPTFLAGS) $(VTEINC) -std=c11 -Wall -pedantic -fno-strict-aliasing -Ofast
 #-g

aNu: src/aNu.o
	$(CC) $(LDFLAGS) src/aNu.o $(LDLIBS) -o src/$(PROG)

src/aNu.o: src/aNu.h

prepare:
	rm -f src/custom.h src/aNu.h src/aNu.o 

src/custom.h: prepare
	sed 's/ CTRL_ALT / CTRL_ALT_FOO /g' $(CONF_FILE) > src/custom.h

src/aNu.h: src/custom.h
	sh src/process.sh src/$(PROG)

strip: aNu
	strip --remove-section=.comment --remove-section=.note src/$(PROG)

install:
	install -d $(bindir)
	install -m 755 src/$(PROG) src/showvte $(bindir)
	install -d $(ICON_DIR_INSTALL)
	install -m 644 misc/48.png $(ICON_DIR_INSTALL)/aNu.png
	install -d $(THEME_DIR)/hicolor/16x16/apps
	install -m 644 misc/16.png $(THEME_DIR)/hicolor/16x16/apps/aNu.png
	install -d $(THEME_DIR)/hicolor/20x20/apps
	install -m 644 misc/20.png $(THEME_DIR)/hicolor/20x20/apps/aNu.png
	install -d $(THEME_DIR)/hicolor/22x22/apps
	install -m 644 misc/22.png $(THEME_DIR)/hicolor/22x22/apps/aNu.png
	install -d $(THEME_DIR)/hicolor/24x24/apps
	install -m 644 misc/24.png $(THEME_DIR)/hicolor/24x24/apps/aNu.png
	install -d $(THEME_DIR)/hicolor/32x32/apps
	install -m 644 misc/32.png $(THEME_DIR)/hicolor/32x32/apps/aNu.png
	install -d $(THEME_DIR)/hicolor/36x36/apps
	install -m 644 misc/36.png $(THEME_DIR)/hicolor/36x36/apps/aNu.png
	install -d $(THEME_DIR)/hicolor/40x40/apps
	install -m 644 misc/40.png $(THEME_DIR)/hicolor/40x40/apps/aNu.png
	install -d $(THEME_DIR)/hicolor/48x48/apps
	install -m 644 misc/48.png $(THEME_DIR)/hicolor/48x48/apps/aNu.png
	install -d $(THEME_DIR)/hicolor/64x64/apps
	install -m 644 misc/64.png $(THEME_DIR)/hicolor/64x64/apps/aNu.png
	install -d $(THEME_DIR)/hicolor/72x72/apps
	install -m 644 misc/72.png $(THEME_DIR)/hicolor/72x72/apps/aNu.png
	install -d $(THEME_DIR)/hicolor/96x96/apps
	install -m 644 misc/96.png $(THEME_DIR)/hicolor/96x96/apps/aNu.png
	install -d $(THEME_DIR)/hicolor/scalable/apps
	install -m 644 misc/aNu.svg $(THEME_DIR)/hicolor/scalable/apps
	install -d $(mandir)
	install -m 644 misc/aNu.1 misc/showvte.1 $(mandir)
	install -d $(deskdir)
	install -m 644 misc/aNu.desktop $(deskdir)
	install -d $(GNOME_DEF_APP)
	install -m 644 misc/aNu.xml $(GNOME_DEF_APP)

install-strip: strip
	sh src/install.sh

uninstall:
	sh src/uninstall.sh

clean: src/config.o
	rm -f src/$(PROG) src/showvte src/aNu.o src/aNu.h misc/aNu.? src/custom.h src/config.o *~ src/*~ misc/*~ src/config.txt

distclean: clean
	rm -f src/*.o src/install.sh src/uninstall.sh  *~ src/*~ misc/*~

src/config.o:
	./configure --quiet

.PHONY: aNu prepare strip install install-strip uninstall clean distclean
