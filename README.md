drmdecrypt
==========

## Synopsis

drmdecrypt is a tool to decrypt recorded files from Samsung TVs
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
Usage: drmdecrypt [-dqvx][-o outdir] infile.srf ...
Options:
   -d         Show debugging output
   -o outdir  Output directory
   -q         Be quiet. Only error output.
   -v         Version information
   -x         Disable AES-NI support
```


## Building / Installing

```
make
make install
```

## Support status

Samsung has changed the encryption of the PVR recordings a few
times so here is a small overview of what the situation is right
now. Situation might change over time.

Model year | Status
---------- | -------
C (2010)   | supported
D (2011)   | supported
E (2012)   | unknown
F (2013)   | unknown
H (2014)   | not supported (unknown key)


## TODO

- default is BUFSIZ or better struct fstat blocksize
- I/O write: write() + O_DIRECT + posix_memalign()
- I/O read: fread(188) + setvbuf(32k+8, _IOFBF)
- OpenMP for multiprocessing: #pragma omp parallel for schedule(static)

