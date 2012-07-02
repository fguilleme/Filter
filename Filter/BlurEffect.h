//
//  BlurEffect.h
//  Filter
//
//  Created by François Guillemé on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>
#import <CoreImage/CoreImage.h>

@interface BlurEffect : CIFilter {
    CIContext *_context;
    CIImage *_image;
    CGFloat _blurRadius;
}

@end
