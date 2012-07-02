//
//  neon.c
//  Filter
//
//  Created by François Guillemé on 6/24/12.
//
//
#if 0
#include <arm_neon.h>

void reference_convert (uint8_t * __restrict dest, uint8_t * __restrict src, int n)
{
    int i;
    for (i=0; i<n; i++)
    {
        int r = *src++; // load red
        int g = *src++; // load green
        int b = *src++; // load blue 
        
        // build weighted average:
        int y = (r*77)+(g*151)+(b*28);
        
        // undo the scale by 256 and write to memory:
        *dest++ = (y>>8);
    }
}

void neon_convert (uint8_t * __restrict dest, uint8_t * __restrict src, int n)
{
    int i;
    uint8x8_t rfac = vdup_n_u8 (77);
    uint8x8_t gfac = vdup_n_u8 (151);
    uint8x8_t bfac = vdup_n_u8 (28);
    n/=8;
    
    for (i=0; i<n; i++)
    {
        uint16x8_t  temp;
        uint8x8x4_t rgb  = vld4_u8 (src);
        uint8x8_t result;
        
        temp = vmull_u8 (rgb.val[0],      rfac);
        temp = vmlal_u8 (temp,rgb.val[1], gfac);
        temp = vmlal_u8 (temp,rgb.val[2], bfac);
        
        result = vshrn_n_u16 (temp, 8);
        vst1_u8 (dest, result);
        src  += 8*3;
        dest += 8;
    }
}
#endif
