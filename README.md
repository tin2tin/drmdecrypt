drmdecrypt
==========

## Synopsis

drmdecrypt is a tool to decrypt PVR recordings from Samsung TVs
into standard transport stream format. There are multiple similar
versions out there based on code from SamyGO and various people
but they are all either slow, Windows specific, full of bugs or
even all together.

This version is fast, POSIX compliant (Linux, FreeBSD, Windows
(MinGW)) and is focused on a small number of useful features.

## Features
- Reading title and channel from .inf file
- Bulk decoding multiple files
- AES-NI support (5x faster)


## Usage

```
Usage: drmdecrypt [-dqvx][-k keyfile][-o outdir] infile.srf ...
Options:
   -d         Show debugging output
   -k keyfile Use custom key file instead of mdb
   -o outdir  Output directory
   -q         Be quiet. Only error output.
   -v         Version information
   -x         Disable AES-NI support
```


## Building

```
make
```

of for MinGW (Windows)

```
CC=gcc make
```

## Support status

Samsung has changed the encryption of the PVR recordings a few
times so here is a small overview of what the situation is right
now. Situation might change over time.

Model year | Status
---------- | -------
C (2010)   | supported
D (2011)   | supported
E (2012)   | key file required (needs root)
F (2013)   | key file required (needs root)
H (2014)   | key file required (needs root)
J (2015)   | unknown
K (2016)   | unknown
M (2017)   | unknown


## Notes for Models E and later

Samsung has moved the decryption keys into the internal storage of
the TV. That makes the process more complicated:

1) get root and ssh on your TV
2) ssh to the box and run PVRdumpkeys.sh to generate .key files from the internal storage
3) unplug the USB disk and plug on a laptop
4) run drmdecrypt on it with -k <keyfile> to decrypt the recording

or you can also use SamyGO NoDRM. See: https://forum.samygo.tv/viewtopic.php?t=8105

