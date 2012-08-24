//
// Created by francois on 8/24/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>
#import <CoreImage/CoreImage.h>
#import <CoreGraphics/CoreGraphics.h>

@interface OpenCVHough : CIFilter {
    CIContext *_context;
    CIImage *_image;
    NSInteger _threshold, _mingap, _minlength;
    bool _over;
}
@end