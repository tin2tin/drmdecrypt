/* drmdecrypt -- DRM decrypting tool for Samsung TVs
 *
 * Copyright (C) 2014 - Bernhard Froehlich <decke@bluelife.at>
 * All rights reserved.
 *
 * This software may be modified and distributed under the terms
 * of the GPL v2 license.  See the LICENSE file for details.
 */

#ifndef _BUFFER_H_
#define _BUFFER_H_

#define READSIZE    4096
#define WRITESIZE   4096
#define PACKETSIZE  188
#define BUFFERSIZE  (READSIZE+READSIZE+PACKETSIZE)

struct packetbuffer
{
   char *buffer;
   char *startp;
   char *workp;
   char *endp;
   int end;
   int fdread;
   int fdwrite;
};

extern int pbinit(struct packetbuffer *pb);
extern int pbfree(struct packetbuffer *pb);
extern int pbread(struct packetbuffer *pb);
extern int pbwrite(struct packetbuffer *pb);

#endif /* _BUFFER_H_ */

