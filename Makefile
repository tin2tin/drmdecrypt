#
# This Makefile requires GNU Make
#

CC	?= cc
CFLAGS	+= -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE
LDFLAGS	+= -static

# add git revision if .git exists
ifeq (,$(wildcard .git))
CFLAGS	+= -DREVISION="unknown"
else
CFLAGS	+= -DREVISION="$(shell git rev-parse --short HEAD)"
endif

# optimizations
CFLAGS	+= -Ofast

# malloc implementation and link to libc/msvcrt
ifeq ($(OS),Windows_NT)
CFLAGS += -DHAVE__ALIGNED_MALLOC
LDFLAGS	+= -lmsvcrt
else
CFLAGS += -DHAVE_POSIX_MEMALIGN
LDFLAGS	+= -lc
endif

# Linux/x64_64 specifics
UNAME_M := $(shell uname -m)

ifeq ($(UNAME_M),x86_64)
CFLAGS += -maes -march=native
SRC += AESNI.c
endif

# FreeBSD/amd64 specifics
ifeq ($(UNAME_M),amd64)
CFLAGS += -maes -march=native
SRC += AESNI.c
endif

##########################

SRC	+= AES.c buffer.c drmdecrypt.c
OBJS	= $(SRC:.c=.o)

all:	drmdecrypt

drmdecrypt:	$(OBJS)

clean:
	rm -f *.o *.core drmdecrypt drmdecrypt.exe
