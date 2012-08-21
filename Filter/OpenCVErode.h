//
//  OpenCVErode.h
//  Filter
//
//  Created by François Guillemé on 8/18/12.
//
//
#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>
#import <CoreImage/CoreImage.h>
#import <CoreGraphics/CoreGraphics.h>

@interface OpenCVErode : CIFilter {
    CIContext *_context;
    CIImage *_image;
    int _value;
    bool _erode;
    NSString *_name;
}
- (id)initWithName:(NSString*)name;
@end
