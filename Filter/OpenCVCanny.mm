//
//  OpenCVCanny.m
//  Filter
//
//  Created by François Guillemé on 8/18/12.
//
//

#import "OpenCVCanny.h"
#import "UIImage+OpenCV.h"

#import <vector>

const int kCannyAperture = 7;

@implementation OpenCVCanny
- (id)init
{
    self = [super init];
    if (self) {
            // Initialization code here.
        _context = [CIContext contextWithOptions:nil];
        _lowFilter = 10;
        _highFilter = 100;
        _hough = NO;
    }
    
    return self;
}

-(NSString *)name {
    return @"OpenCV Canny";
}

-(NSString*)description {
    return [self name];
}

-(void)setValue:(id)value  forKey:(NSString*)key {
    if ([key compare:@"inputImage"] == 0) {
        _image = value;
    }
    else if ([key compare:@"Low filter"] == 0) {
        NSNumber *number = value;
        _lowFilter = [number floatValue];
    }
    else if ([key compare:@"High filter"] == 0) {
        NSNumber *number = value;
        _highFilter = [number floatValue];
    }
    else if ([key compare:@"Hough"] == 0) {
        NSNumber *number = value;
        _hough = [number boolValue];
    }
}

-(NSDictionary *)attributes {
    
    NSDictionary *lowDict =  @{ @"CIAttributeFilterDisplayName": @"Low filter",
                                @"CIAttributeClass": @"NSNumber",
                                @"CIAttributeSliderMin":@1,
                                @"CIAttributeSliderMax":@300,
                                @"DiscreteSlider": @YES
    };
    NSDictionary *highDict = @{ @"CIAttributeFilterDisplayName": @"High filter",
                                @"CIAttributeClass": @"NSNumber",
                                @"CIAttributeSliderMin":@1,
                                @"CIAttributeSliderMax":@600,
                                @"DiscreteSlider": @YES
    };
    NSDictionary *houghDict = @{ @"CIAttributeFilterDisplayName": @"Hough",
                                 @"CIAttributeClass": @"NSBool",
    };
    
    return @{   @"Low filter" : lowDict,
                @"High filter" : highDict,
                @"Hough" : houghDict,
                @"inputImage": @"",
                @"CIAttributeFilterDisplayName": @"Canny"
    };
}

-(id)valueForKey:(NSString *)key {
    if ([key compare:@"Low filter"] == 0) {
        return [NSNumber numberWithFloat:_lowFilter];
    }
    if ([key compare:@"High filter"] == 0) {
        return [NSNumber numberWithFloat:_highFilter];
    }
    if ([key compare:@"Hough"] == 0) {
        return [NSNumber numberWithBool:_hough];
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
    sz.height = sz.width = _lowFilter;
    
        // Convert captured frame to grayscale
    cv::cvtColor(mat, grayframe, cv::COLOR_RGB2GRAY);
    
        // Perform Canny edge detection using slide values for thresholds
    cv::Canny(grayframe, output,
              _lowFilter * kCannyAperture * kCannyAperture,
              _highFilter * kCannyAperture * kCannyAperture,
              kCannyAperture);

    if (_hough) {
        std::vector<cv::Vec4i> lines;
        
        HoughLinesP(output, lines, 1, CV_PI/180, 50, 50, 10 );
        
        mat = cv::Scalar(0);
        
        for (int i = 0; i < lines.size(); i++) {
            cv::Vec4i &line = lines[i];

            cv::Point pt1(line.operator()(0), line.operator()(1));
            cv::Point pt2(line.operator()(2), line.operator()(3));
            
            cv::line( mat, pt1, pt2, cv::Scalar(255,0,0));
        }
    }
    else {
        mat = output;
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


