//
//  BlackAndWhite.m
//  Filter
//
//  Created by François Guillemé on 8/20/12.
//
//

#import "BlackAndWhite.h"

@implementation BlackAndWhite

- (id)init
{
    self = [super init];
    if (self) {
            // Initialization code here.
        _context = [CIContext contextWithOptions:nil];
    }
    
    return self;
}

-(NSString *)name {
    return @"B&W";
}

-(NSString*)description {
    return [self name];
}

-(void)setValue:(id)value  forKey:(NSString*)key {
    if ([key compare:@"inputImage"] == 0) {
        _image = value;
    }
}

-(NSDictionary *)attributes {
    
    return @{
            @"inputImage": @"",
            @"CIAttributeFilterDisplayName": @"B&W"
            };
}

-(id)valueForKey:(NSString *)key {
    if ([key compare:@"outputImage"] == 0) {
        return [self outputImage];
    }
    return nil;
}

-(CIImage*)outputImage {
    CGImageRef cg = [_context createCGImage:_image fromRect:_image.extent];
    if (cg == nil) return nil;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();

    CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
                                       CGImageGetWidth(cg),
                                       CGImageGetHeight(cg),
                                       8,
                                       0,
                                       colorSpace,
                                       kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(bitmapContext, CGRectMake(0, 0, CGBitmapContextGetWidth(bitmapContext), CGBitmapContextGetHeight(bitmapContext)), cg);

    CGImageRef res = CGBitmapContextCreateImage(bitmapContext);
    if (res == nil) {
        CFRelease(cg);
        CFRelease(bitmapContext);
        return nil;
    }
    CFRelease(bitmapContext);

    CIImage *im = [CIImage imageWithCGImage:res];
    CFRelease(cg);
    CFRelease(res);
    _image = nil;
    return im;
}

@end
