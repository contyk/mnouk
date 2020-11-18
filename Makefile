app = mnouk

cflags = -std=c99 -D_DEFAULT_SOURCE -Wall
ldflags = -lX11

prefix ?= /usr
exec_prefix ?= $(prefix)
includedir ?= $(prefix)/include
datarootdir ?= $(prefix)/share
bindir ?= $(exec_prefix)/bin
mandir ?= $(datarootdir)/man

src = $(wildcard *.c)
obj = $(src:.c=.o)

CC ?= cc
CFLAGS ?= -march=native -Ofast -fgraphite-identity -floop-nest-optimize -fdevirtualize-at-ltrans -fipa-pta -fno-semantic-interposition -falign-functions=32 -flto=8 -fuse-linker-plugin -pipe
LDFLAGS ?= $(CFLAGS) -Wl,-O1 -Wl,--as-needed -Wl,--sort-common -Wl,--hash-style=gnu -z combreloc

ifdef DEBUG
	cflags += -g
else
	ldflags += -s
endif

all: $(app)

%.o: %.c
	$(CC) $(cflags) -I$(includedir) $(CFLAGS) -o $@ -c $<

$(app): $(obj)
	$(CC) -o $@ $^ $(ldflags) $(LDFLAGS)

install: $(app)
	mkdir -p $(DESTDIR)$(bindir)
	install -m0755 $< $(DESTDIR)$(bindir)/$(app)

uninstall:
	rm -vf $(DESTDIR)$(bindir)/$(app)

clean:
	rm -f $(obj) $(app)

check:
	@echo No tests currently implemented.
	@echo Testing DEBUG: $(DEBUG?no)

.PHONY: all clean install uninstall check
