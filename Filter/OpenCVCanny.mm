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
    
    return @{   @"Low filter" : lowDict,
                @"High filter" : highDict,
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

    std::vector<cv::Vec2f> lines;
//    HoughLines(output, lines, 10, CV_PI/180, 100, 0, 0 );
//
//    for (int i = 0; i < lines.size(); i++) {
//        float rho = lines[i][0], theta = lines[i][1];
//        cv::Point pt1, pt2;
//        double a = cos(theta), b = sin(theta);
//        double x0 = a*rho, y0 = b*rho;
//        pt1.x = cvRound(x0 + 1000*(-b));
//        pt1.y = cvRound(y0 + 1000*(a));
//        pt2.x = cvRound(x0 - 1000*(-b));
//        pt2.y = cvRound(y0 - 1000*(a));
//        
////        CGContextMoveToPoint(ctx, pt1.x, pt1.y);
////        CGContextAddLineToPoint(ctx, pt2.x, pt2.y);
//        cv::line( output, pt1, pt2, cv::Scalar(0,0,255), 3, CV_AA);
//    }
    CFRelease(cg);
    
    UIImage *im0 = [UIImage imageWithCVMat:output];
    cg = im0.CGImage;
    
    if (cg == nil) return nil;
    
    CIImage *im = [CIImage imageWithCGImage:cg];
    _image = nil;
    return im;
}
@end


