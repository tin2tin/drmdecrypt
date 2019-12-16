#
# This Makefile requires GNU Make
#

CC	?= cc
CFLAGS	+= -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE

# add git revision if .git exists
ifeq (,$(wildcard .git))
CFLAGS	+= -DREVISION="unknown"
else
CFLAGS	+= -DREVISION="$(shell git rev-parse --short HEAD)"
endif

# general optimizations
CFLAGS	+= -Ofast

# platform/arch specifics
UNAME_S := $(shell uname -s)
UNAME_M := $(shell uname -m)

ifeq ($(OS),Windows_NT)
	# malloc implementation and link to libc/msvcrt
	CFLAGS += -DHAVE__ALIGNED_MALLOC
	LDFLAGS	+= -lmsvcrt

	# aesni
	CFLAGS += -maes -march=native
	SRC += AESNI.c
endif
ifeq ($(UNAME_S),Linux)
	CFLAGS += -DHAVE_POSIX_MEMALIGN
	LDFLAGS	+= -lc -static

ifeq ($(UNAME_M),x86_64)
	CFLAGS += -maes -march=native
	SRC += AESNI.c
endif
endif
ifeq ($(UNAME_S),FreeBSD)
	CFLAGS += -DHAVE_POSIX_MEMALIGN
	LDFLAGS	+= -lc -static

ifeq ($(UNAME_M),amd64)
	CFLAGS += -maes -march=native
	SRC += AESNI.c
endif
endif
ifeq ($(UNAME_S),Darwin)
	CFLAGS += -DHAVE_POSIX_MEMALIGN
	LDFLAGS += -lc
endif

##########################

SRC	+= AES.c buffer.c drmdecrypt.c
OBJS	= $(SRC:.c=.o)

all:	drmdecrypt

drmdecrypt:	$(OBJS)

clean:
	rm -f *.o *.core drmdecrypt drmdecrypt.exe
