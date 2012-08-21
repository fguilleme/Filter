//
//  EmbossEffect.m
//  Filter
//
//  Created by François Guillemé on 7/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConvolveEffect.h"

static CGImageRef CGConvolveImageARGB8888(CGImageRef imageToConvolve, short kernel[], uint32_t size) {
    
    CGDataProviderRef p = CGImageGetDataProvider(imageToConvolve);
    CFDataRef dataref = CGDataProviderCopyData(p);
    UInt8 *data = (UInt8 *)CFDataGetBytePtr(dataref);
    int length = CFDataGetLength(dataref);
    
    size_t width = CGImageGetWidth(imageToConvolve);
    size_t height = CGImageGetHeight(imageToConvolve);
    
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageToConvolve);
    size_t bitsPerPixel = CGImageGetBitsPerPixel(imageToConvolve);
    size_t bytesPerRow = CGImageGetBytesPerRow(imageToConvolve);
    CGColorSpaceRef colorspace = CGImageGetColorSpace(imageToConvolve);
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageToConvolve);
    vImage_Buffer src = { data, height, width, bytesPerRow }; 
    void *newdata = malloc(length);
    
    vImage_Buffer dest = { newdata, height, width, bytesPerRow }; 
    unsigned char bgColor[4] = { 0, 0, 0, 0 }; 
    vImage_Error err; 
    vImage_Flags flags = kvImageBackgroundColorFill;
    
    uint32_t div = 0;
    
    for (int i = 0; i < size * size; i++) div += kernel[i];
    if (div == 0) div = 1;
    
    // call a diffrent function depending of colorscape
    if (bitsPerComponent == 8 && bitsPerPixel == 32)
        err = vImageConvolve_ARGB8888(&src, &dest, NULL, 0, 0, kernel, size, size, div, bgColor, flags);
    else if (bitsPerComponent == 8 && bitsPerPixel == 8)
        err = vImageConvolve_Planar8(&src, &dest, NULL, 0, 0, kernel, size, size, div, bgColor[0], flags);
    else 
        err = kvImageInvalidParameter;
    
    if (err == kvImageNoError) {
        CFDataRef newData = CFDataCreate(NULL, newdata, length);
        
        CGDataProviderRef provider = CGDataProviderCreateWithCFData(newData);
        
        imageToConvolve = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorspace, bitmapInfo, provider, NULL, true, kCGRenderingIntentDefault);
        
        CFRelease(newData);
        CFRelease(provider);
    }
    else {
        NSLog(@"Convolve failed err = %ld", err);
        CFRetain(imageToConvolve);
    }
    
    free(newdata);
    CFRelease(dataref);
    
    return imageToConvolve;
}

static CGImageRef CGDilateImageARGB8888(CGImageRef imageToDilate, void *kernel, uint32_t size) {
    CGDataProviderRef p = CGImageGetDataProvider(imageToDilate);
    CFDataRef dataref = CGDataProviderCopyData(p);
    UInt8 *data = (UInt8 *)CFDataGetBytePtr(dataref);
    int length = CFDataGetLength(dataref);
    
    size_t width = CGImageGetWidth(imageToDilate);
    size_t height = CGImageGetHeight(imageToDilate);
    
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageToDilate);
    size_t bitsPerPixel = CGImageGetBitsPerPixel(imageToDilate);
    size_t bytesPerRow = CGImageGetBytesPerRow(imageToDilate);
    CGColorSpaceRef colorspace = CGImageGetColorSpace(imageToDilate);
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageToDilate);
    vImage_Buffer src = { data, height, width, bytesPerRow };
    void *newdata = malloc(length);
    
    vImage_Buffer dest = { newdata, height, width, bytesPerRow };
    vImage_Error err;
    vImage_Flags flags = kvImageLeaveAlphaUnchanged;
    const int xoffset = 0, yoffset = 0;
   
        // call a diffrent function depending of colorscape
    if (bitsPerComponent == 8 && bitsPerPixel == 32)
        err = vImageDilate_ARGB8888(&src, &dest, xoffset, yoffset, kernel, size, size, flags);
    else if (bitsPerComponent == 8 && bitsPerPixel == 8)
        err = vImageDilate_Planar8(&src, &dest, xoffset, yoffset, kernel, size, size, flags);
    else
        err = kvImageInvalidParameter;
    
    if (err == kvImageNoError) {
        CFDataRef newData = CFDataCreate(NULL, newdata, length);
        
        CGDataProviderRef provider = CGDataProviderCreateWithCFData(newData);
        
        imageToDilate = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorspace, bitmapInfo, provider, NULL, true, kCGRenderingIntentDefault);
        
        CFRelease(newData);
        CFRelease(provider);
    }
    else {
        NSLog(@"Convolve failed err = %ld", err);
        CFRetain(imageToDilate);
    }
    
    free(newdata);
    CFRelease(dataref);
    
    return imageToDilate;
}


@implementation ConvolveEffect

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        _context = [CIContext contextWithOptions:nil];
    }
    
    return self;
}

-(NSString*)description {
    return [self name];
}

-(CIImage *)convolveImage:(CIImage *)image withKernel:(short *)kernel ofSize:(uint32_t)size {
    CGImageRef cg = [_context createCGImage:image fromRect:image.extent];
    if (cg == nil) return nil;
    
    CGImageRef res = CGConvolveImageARGB8888(cg, kernel, size);
    if (res == nil) {
        CFRelease(cg);
        return nil;
    }
    CIImage *im = [CIImage imageWithCGImage:res];
    CFRelease(cg);
    CFRelease(res);
    return im;
}
@end


@implementation BaseDilateEffect

- (id)init
{
    self = [super init];
    if (self) {
            // Initialization code here.
        _context = [CIContext contextWithOptions:nil];
    }
    
    return self;
}

-(NSString*)description {
    return [self name];
}

-(CIImage *)dilateImage:(CIImage *)image withKernel:(short *)kernel ofSize:(uint32_t)size {
    CGImageRef cg = [_context createCGImage:image fromRect:image.extent];
    if (cg == nil) return nil;
    
    CGImageRef res = CGDilateImageARGB8888(cg, kernel, size);
    if (res == nil) {
        CFRelease(cg);
        return nil;
    }
    CIImage *im = [CIImage imageWithCGImage:res];
    CFRelease(cg);
    CFRelease(res);
    return im;
}
@end
