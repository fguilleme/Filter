//
//  OpenCVBlur.mm
//  Filter
//
//  Created by François Guillemé on 8/18/12.
//
//

#import "OpenCVBlur.h"
#import "UIImage+OpenCV.h"

@implementation OpenCVBlur
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
    return @"OpenCV Blur";
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

    NSDictionary *radiusDict = @{ @"CIAttributeFilterDisplayName": @"Blur radius",
    @"CIAttributeClass": @"NSNumber",
    @"CIAttributeSliderMin":@1,
    @"CIAttributeSliderMax":@60,
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
    cv::Mat output, mat = [UIImage imageWithCGImage:cg].CVMat;
    cv::Size sz;
    sz.height = sz.width = _blurRadius;
    
    cv::blur(mat, output, sz);
    
    CFRelease(cg);
   
    cg = [UIImage imageWithCVMat:output].CGImage;
    
    if (cg == nil) return nil;
    
    CIImage *im = [CIImage imageWithCGImage:cg];
    _image = nil;
    return im;
}
@end

