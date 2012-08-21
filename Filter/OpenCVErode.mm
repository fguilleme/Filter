//
//  OpenCVErode.m
//  Filter
//
//  Created by François Guillemé on 8/18/12.
//
//

#import "OpenCVErode.h"
#import "UIImage+OpenCV.h"

@implementation OpenCVErode
- (id)initWithName:(NSString*)name
{
    self = [super init];
    if (self) {
            // Initialization code here.
        _context = [CIContext contextWithOptions:nil];
        if ([name compare:@"Erode"] == 0)
            _erode = YES;
        else
            _erode = NO;
        
        _value = 1;
        _name = name;
    }
    
    return self;
}

-(NSString *)name {
    return [NSString stringWithFormat:@"OpenCV %@", _name];
}

-(NSString*)description {
    return [self name];
}

-(void)setValue:(id)value  forKey:(NSString*)key {
    if ([key compare:@"inputImage"] == 0) {
        _image = value;
    }
    else if ([key compare:@"Value"] == 0) {
        NSNumber *number = value;
        _value = [number intValue];
    }
}

-(NSDictionary *)attributes {
    
    NSDictionary *lowDict =  @{ @"CIAttributeFilterDisplayName": @"Value",
                                @"CIAttributeClass": @"NSNumber",
                                @"CIAttributeSliderMin":@1,
                                @"CIAttributeSliderMax":@4,
                                @"DiscreteSlider": @YES
    };

    
    return @{   @"Value" : lowDict,
                @"inputImage": @"",
                @"CIAttributeFilterDisplayName": _name
    };
}

-(id)valueForKey:(NSString *)key {
    if ([key compare:@"Value"] == 0) {
        return @(_value);
    }
    if ([key compare:@"outputImage"] == 0) {
        return [self outputImage];
    }
    return nil;
}

-(CIImage*)outputImage {
    CGImageRef cg = [_context createCGImage:_image fromRect:_image.extent];
    cv::Mat output, mat = [UIImage imageWithCGImage:cg].CVMat;

    cv::Mat element = getStructuringElement( cv::MORPH_ELLIPSE,
                                            cv::Size( 2*_value + 1, 2*_value+1 ),
                                            cv::Point( _value, _value ) );

    if (_erode) {
        cv::erode(mat, output, element);
    }
    else {
        cv::dilate(mat, output, element);
    }
    
    CFRelease(cg);
    
    cg = [UIImage imageWithCVMat:output].CGImage;
    
    if (cg == nil) return nil;
    
    CIImage *im = [CIImage imageWithCGImage:cg];
    _image = nil;
    return im;
}

@end
