#
# This Makefile requires GNU Make
#

CC	?= cc
LD	?= ld
CFLAGS	+= -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -maes

INSTALL	= install -c
STRIP	= strip
PREFIX	= /usr/local
BINDIR	= $(PREFIX)/bin
VERSION	= 1.0

# add git revision if .git exists
ifeq (,$(wildcard .git))
CFLAGS	+= -DREVISION="unknown"
else
CFLAGS	+= -DREVISION="$(shell git rev-parse --short HEAD)"
endif

ifeq ($(DEBUG),1)
# for debugging
CFLAGS	+= -g -Wall -Werror
LDFLAGS	+= -pg
else
# for release
CFLAGS	+= -Ofast

# enable LTO for gcc
ifeq ($(shell $(CC) --version | grep gcc >/dev/null; echo $$?),0)
CFLAGS	+= -flto
LDFLAGS	+= -flto
endif
endif

# we need to link to libc/msvcrt
ifeq ($(OS),Windows_NT)
CFLAGS += -DHAVE__ALIGNED_MALLOC
LDFLAGS	+= -lmsvcrt
else
CFLAGS += -DHAVE_POSIX_MEMALIGN
LDFLAGS	+= -lc
endif

RELDIR	= drmdecrypt-$(VERSION)

##########################

SRC	= AES.c AESNI.c drmdecrypt.c
OBJS	= AES.o AESNI.o drmdecrypt.o

all:	drmdecrypt

drmdecrypt:	$(OBJS)
	$(CC) $(LDFLAGS) -o $@ $(OBJS)

drmdecrypt-static:	$(OBJS)
	$(CC) $(LDFLAGS) -static -o $@ $(OBJS)

install:	all
	$(STRIP) drmdecrypt
	$(INSTALL) drmdecrypt $(BINDIR)/drmdecrypt

release-win:	all
	rm -rf $(RELDIR)-win
	mkdir $(RELDIR)-win
	cp LICENSE README.md drmdecrypt.exe $(RELDIR)-win
	$(STRIP) $(RELDIR)-win/*.exe

release-x64:	drmdecrypt drmdecrypt-static
	rm -rf $(RELDIR)-x64
	mkdir $(RELDIR)-x64
	cp LICENSE README.md drmdecrypt drmdecrypt-static $(RELDIR)-x64
	tar cvfj $(RELDIR)-x64.tar.bz2 $(RELDIR)-x64

release-src:
	rm -rf $(RELDIR)-src
	mkdir $(RELDIR)-src
	cp LICENSE README.md *.c *.h Makefile $(RELDIR)-src
	tar cvfj $(RELDIR)-src.tar.bz2 $(RELDIR)-src

clean:
	rm -f *.o *.core drmdecrypt drmdecrypt.exe
	rm -rf $(RELDIR)

