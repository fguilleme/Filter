 //
//  BlurEffect.m
//  Filter
//
//  Created by François Guillemé on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BlurEffect.h"

static CGImageRef CGBlurImageARGB8888(CGImageRef imageToBlur, uint32_t radius) {

    CGDataProviderRef p = CGImageGetDataProvider(imageToBlur);
    CFDataRef dataref = CGDataProviderCopyData(p);
    if (dataref == nil) return nil;
    
    UInt8 *data = (UInt8 *)CFDataGetBytePtr(dataref);
    int length = CFDataGetLength(dataref);
    
    size_t width = CGImageGetWidth(imageToBlur);
    size_t height = CGImageGetHeight(imageToBlur);
    
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageToBlur);
    size_t bitsPerPixel = CGImageGetBitsPerPixel(imageToBlur);
    size_t bytesPerRow = CGImageGetBytesPerRow(imageToBlur);
    CGColorSpaceRef colorspace = CGImageGetColorSpace(imageToBlur);
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageToBlur);
    vImage_Buffer src = { data, height, width, bytesPerRow }; // 2
    void *newdata = malloc(length);
    
    vImage_Buffer dest = { newdata, height, width, bytesPerRow }; // 3
    unsigned char bgColor[4] = { 0, 0, 0, 0 }; // 4
    vImage_Error err; // 5
    vImage_Flags flags = kvImageBackgroundColorFill;

    radius = (radius &-2) + 1;
    
    // call a diffrent function depending of colorscape
    err = vImageTentConvolve_ARGB8888 (&src, &dest, NULL, 0, 0, (uint32_t) radius, (uint32_t) radius, bgColor, flags); 
    if (err == kvImageNoError) {
        CFDataRef newData = CFDataCreate(NULL, newdata, length);
        
        CGDataProviderRef provider = CGDataProviderCreateWithCFData(newData);
        
        imageToBlur = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorspace, bitmapInfo, provider, NULL, true, kCGRenderingIntentDefault);
        
        CFRelease(newData);
        CFRelease(provider);
    }
    else {
        NSLog(@"Convolution radius = %u failed err = %ld", radius, err);
        CFRetain(imageToBlur);
    }
    
    free(newdata);
    CFRelease(dataref);
    
    return imageToBlur;
}


@implementation BlurEffect

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        _context = [CIContext contextWithOptions:nil];
        _blurRadius = 5;
    }
    
    return self;
}

-(NSString *)name {
    return @"Blur";
}

-(NSString*)description {
    return [self name];
}

-(void)setValue:(id)value  forKey:(NSString*)key {
    if ([key compare:@"inputImage"] == 0) {
        _image = value;
     }  
    else if ([key compare:@"blurRadius"] == 0) {
        NSNumber *number = value;
        _blurRadius = [number floatValue];
    }
}

-(NSDictionary *)attributes {
//    NSDictionary *radiusDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Blur radius", @"NSNumber", @"1", @"30", @"YES", nil]
//                                                           forKeys:[NSArray arrayWithObjects:@"CIAttributeFilterDisplayName", @"CIAttributeClass", @"CIAttributeSliderMin", @"CIAttributeSliderMax", @"DiscreteSlider", nil]];
//    return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:radiusDict, @"", @"Blur", nil]
//                                        forKeys:[NSArray arrayWithObjects:@"blurRadius", @"inputImage", @"CIAttributeFilterDisplayName", nil]
//            ];
    
    NSDictionary *radiusDict = @{ @"CIAttributeFilterDisplayName": @"Blur radius",
                                  @"CIAttributeClass": @"NSNumber",
                                  @"CIAttributeSliderMin":@1,
                                  @"CIAttributeSliderMax":@30,
                                  @"DiscreteSlider": @YES
                                };
    
    return @{ @"blurRadius" : radiusDict,
              @"inputImage": @"",
              @"CIAttributeFilterDisplayName": @"Blur"
            };
}

-(id)valueForKey:(NSString *)key {
    if ([key compare:@"blurRadius"] == 0) {
        return [NSNumber numberWithFloat:_blurRadius];
    }
    if ([key compare:@"outputImage"] == 0) {
        return [self outputImage];
    }
    return nil;
}

-(CIImage*)outputImage {
    CGImageRef cg = [_context createCGImage:_image fromRect:_image.extent];
    if (cg == nil) return nil;
    
    CGImageRef res = CGBlurImageARGB8888(cg, _blurRadius * 2 + 1);
    if (res == nil) {
        CFRelease(cg);
        return nil;
    }
    CIImage *im = [CIImage imageWithCGImage:res];
    CFRelease(cg);
    CFRelease(res);
    _image = nil;
    return im;
}
@end
