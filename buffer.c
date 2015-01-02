/* drmdecrypt -- DRM decrypting tool for Samsung TVs
 *
 * Copyright (C) 2014 - Bernhard Froehlich <decke@bluelife.at>
 * All rights reserved.
 *
 * This software may be modified and distributed under the terms
 * of the GPL v2 license.  See the LICENSE file for details.
 */

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

#include "buffer.h"

int pbinit(struct packetbuffer *pb)
{
   if(pb == NULL)
      return 1;

   pbfree(pb);

   pb->buffer = malloc(BUFFERSIZE);
   if(pb->buffer == NULL){
      printf("malloc failed\n");
      return 1;
   }
   memset(pb->buffer, 0, BUFFERSIZE);

   pb->startp = pb->buffer;
   pb->workp = pb->buffer;
   pb->endp = pb->buffer;
   pb->end = 0;

   return 0;
}

int pbfree(struct packetbuffer *pb)
{
   if(pb == NULL)
      return 1;

   if(pb->buffer != NULL)
      free(pb->buffer);
   
   pb->startp = NULL;
   pb->workp = NULL;
   pb->endp = NULL;
   pb->end = 0;

   return 0;
}

int pbread(struct packetbuffer *pb)
{
   ssize_t tmp;

   /* read chunks of READSIZE to fill up buffer */
   while(pb->buffer + BUFFERSIZE - pb->endp >= READSIZE && pb->end == 0){
      tmp = read(pb->fdread, pb->endp, READSIZE);
      if(tmp < 1)
         pb->end = 1;

      pb->endp += tmp;
   }

   return 0;
}

int pbwrite(struct packetbuffer *pb)
{
   /* write chunks of WRITESIZE */
   while(pb->workp - pb->startp >= WRITESIZE)
      pb->startp += write(pb->fdwrite, pb->startp, WRITESIZE);

   /* write remaining bytes at end of file */
   while(pb->workp - pb->startp > 0 && pb->end == 1)
      pb->startp += write(pb->fdwrite, pb->startp, pb->workp - pb->startp);

   /* copy over remaining bytes */
   if(pb->endp - pb->startp > 0)
      memcpy(pb->buffer, pb->startp, pb->endp - pb->startp);

   pb->endp = pb->buffer + (pb->endp - pb->startp);
   pb->workp = pb->buffer + (pb->workp - pb->startp);
   pb->startp = pb->buffer;

   return 0;
}

