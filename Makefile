PACKAGE = ca.vtrlx.Parchment
VERSION = beta

APPID = $(PACKAGE)
ifdef DEVEL
CFLAGS += -DDEVEL
APPID = $(PACKAGE).Devel
endif

PREFIX = /app

CSRCS = $(wildcard *.c)
LSRCS = $(wildcard *.lua)
RESXML = data/parchment.gresource.xml
RES = $(patsubst %.xml, %, $(RESXML))

BIN = parchment
BYTECODE = $(patsubst %.lua, %.bytecode, $(LSRCS))
LIBS = -llua -ldl -lm
CFLAGS += $(LIBS) -Wl,-E -DVERSION=$(VERSION)

DESKTOP_FILE = $(APPID).desktop
ICON = $(APPID).svg
SYMBOLIC = $(APPID)-symbolic.svg

all: $(BIN)

$(BIN): $(CSRCS) $(BYTECODE)
	cc -o $@ $(CSRCS) -L/app/lib $(CFLAGS)

%.gresource: %.gresource.xml
	glib-compile-resources --target=$@ --sourcedir=data $^

%.bytecode: %.lua
	luac -o $@ -- $<

.PHONY: clean install

clean:
	rm -f $(BIN) $(BYTECODE)

install: $(BIN)
	install -D -m 0755 -t $(PREFIX)/bin $<
	install -D -m 0644 -t $(PREFIX)/share/applications $(DESKTOP_FILE)
	install -D -m 0644 -t $(PREFIX)/share/icons/hicolor/128x128/apps icons/$(ICON)
	install -D -m 0644 -t $(PREFIX)/share/icons/hicolor/symbolic/apps icons/$(SYMBOLIC)
