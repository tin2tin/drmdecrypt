/* drmdecrypt -- DRM decrypting tool for Samsung TVs
 *
 * Copyright (C) 2014 - Bernhard Froehlich <decke@bluelife.at>
 * All rights reserved.
 *
 * This software may be modified and distributed under the terms
 * of the GPL v2 license.  See the LICENSE file for details.
 */

#ifndef __AES_H
#define __AES_H

#define MAXKC	(256/32)
#define MAXKB	(256/8)
#define MAXNR	14

#define BLOCK_SIZE	16

typedef unsigned char	u8;	
typedef unsigned short	u16;	
typedef unsigned int	u32;

typedef struct {
   u32 ek[ 4*(MAXNR+1) ];
   u32 dk[ 4*(MAXNR+1) ];
   int rounds;
} block_state;


/* AES */
extern void block_init_aes(block_state *state, unsigned char *key, int keylen);
extern void block_finalize_aes(block_state* self);
extern void block_encrypt_aes(block_state *self, u8 *in, u8 *out);
extern void block_decrypt_aes(block_state *self, u8 *in, u8 *out);

/* AES-NI */
#ifdef __AES__
extern void block_init_aesni(block_state *state, unsigned char *key, int keylen);
extern void block_finalize_aesni(block_state* self);
extern void block_encrypt_aesni(block_state *self, u8 *in, u8 *out);
extern void block_decrypt_aesni(block_state *self, u8 *in, u8 *out);
#endif

#endif /* __AES_H */

