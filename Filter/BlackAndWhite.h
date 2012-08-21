//
//  BlackAndWhite.h
//  Filter
//
//  Created by François Guillemé on 8/20/12.
//
//
#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>
#import <CoreImage/CoreImage.h>


@interface BlackAndWhite : CIFilter {
    CIContext *_context;
    CIImage *_image;
}

@end
