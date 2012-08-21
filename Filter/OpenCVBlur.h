//
//  OpenCVBlur.h
//  Filter
//
//  Created by François Guillemé on 8/18/12.
//
//
#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>
#import <CoreImage/CoreImage.h>
#import <CoreGraphics/CoreGraphics.h>

@interface OpenCVBlur : CIFilter {
    CIContext *_context;
    CIImage *_image;
    CGFloat _blurRadius;
}

@end