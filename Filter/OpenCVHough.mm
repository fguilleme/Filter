//
// Created by francois on 8/24/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "OpenCVHough.h"
#import "UIImage+OpenCV.h"

#import <vector>

@implementation OpenCVHough
const int kCannyAperture = 7;

- (id)init
{
    self = [super init];
    if (self) {
        _context = [CIContext contextWithOptions:nil];
        
        _threshold = _mingap = _minlength = 50;
        _over = NO;
    }

    return self;
}

-(NSString *)name {
    return @"OpenCV Hough";
}

-(NSString*)description {
    return [self name];
}

-(void)setValue:(id)value  forKey:(NSString*)key {
    if ([key compare:@"inputImage"] == 0) {
        _image = value;
    }
    else if ([key compare:@"Threshold"] == 0) {
        NSNumber *number = value;
        _threshold = [number integerValue];
    }
    else if ([key compare:@"Minimum gap"] == 0) {
        NSNumber *number = value;
        _mingap = [number integerValue];
    }
    else if ([key compare:@"Minimum length"] == 0) {
        NSNumber *number = value;
        _minlength = [number integerValue];
    }
    else if ([key compare:@"Over"] == 0) {
        NSNumber *number = value;
        _over = [number boolValue];
    }
}

-(NSDictionary *)attributes {

    NSDictionary *thresholdDict =  @{ @"CIAttributeFilterDisplayName": @"Threshold",
                                        @"CIAttributeClass": @"NSNumber",
                                        @"CIAttributeSliderMin":@1,
                                        @"CIAttributeSliderMax":@300,
                                        @"DiscreteSlider": @YES
    };
    NSDictionary *lengthDict = @{ @"CIAttributeFilterDisplayName": @"Minimum length",
                                    @"CIAttributeClass": @"NSNumber",
                                    @"CIAttributeSliderMin":@1,
                                    @"CIAttributeSliderMax":@300,
                                    @"DiscreteSlider": @YES
    };
    NSDictionary *gapDict = @{ @"CIAttributeFilterDisplayName": @"Minimum gap",
                                @"CIAttributeClass": @"NSNumber",
                                @"CIAttributeSliderMin":@1,
                                @"CIAttributeSliderMax":@300,
                                @"DiscreteSlider": @YES
    };
    NSDictionary *overDict = @{ @"CIAttributeFilterDisplayName": @"Over",
                                @"CIAttributeClass": @"NSBool",
    };
    return @{   @"Threshold" : thresholdDict,
                @"Minimum length" : lengthDict,
                @"Minimum gap" : gapDict,
                @"Over" : overDict,
                @"inputImage": @"",
                @"CIAttributeFilterDisplayName": @"Hough"
    };
}

-(id)valueForKey:(NSString *)key {
    if ([key compare:@"Threshold"] == 0) {
        return [NSNumber numberWithInteger:_threshold];
    }
    if ([key compare:@"Minimum length"] == 0) {
        return [NSNumber numberWithInteger:_minlength];
    }
    if ([key compare:@"Minimum gap"] == 0) {
        return [NSNumber numberWithInteger:_mingap];
    }
    if ([key compare:@"Over"] == 0) {
        return [NSNumber numberWithBool:_over];
    }
    if ([key compare:@"outputImage"] == 0) {
        return [self outputImage];
    }
    return nil;
}

-(CIImage*)outputImage {
    CGImageRef cg = [_context createCGImage:_image fromRect:_image.extent];
    cv::Mat grayframe, output, mat = [UIImage imageWithCGImage:cg].CVMat;
    cv::Size sz;
    sz.height = sz.width = 300;

    // Convert captured frame to grayscale
    cv::cvtColor(mat, grayframe, cv::COLOR_RGB2GRAY);

    // Perform Canny edge detection using slide values for thresholds
    cv::Canny(grayframe, output,
            300 * kCannyAperture * kCannyAperture,
            600 * kCannyAperture * kCannyAperture,
            kCannyAperture);

    
    std::vector<cv::Vec4i> lines;

    HoughLinesP(output, lines, 1, CV_PI/180, _threshold, _minlength, _mingap );

    if (_over == NO) mat = cv::Scalar(0);

    for (int i = 0; i < lines.size(); i++) {
        cv::Vec4i &line = lines[i];

        cv::Point pt1(line[0], line[1]);
        cv::Point pt2(line[2], line[3]);

        cv::line( mat, pt1, pt2, cv::Scalar(255,0,0), 1);
    }

    CFRelease(cg);

    UIImage *im0 = [UIImage imageWithCVMat:mat];
    cg = im0.CGImage;

    if (cg == nil) return nil;

    CIImage *im = [CIImage imageWithCGImage:cg];
    _image = nil;
    return im;
}

@end