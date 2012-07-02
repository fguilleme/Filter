//
//  UIImage+resize.m
//  CI3
//
//  Created by François Guillemé on 6/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIImage+resize.h"

@implementation UIImage (UIImage_resize)

- (UIImage*)resizeToSize:(CGSize)size
{
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(size,  NO, 1);
    else
        UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Flip the context because UIKit coordinate system is upside down to Quartz coordinate system
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // Draw the original image to the context
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextDrawImage(context, CGRectMake(0.0, 0.0, size.width, size.height), self.CGImage);
    
    // Retrieve the UIImage from the current context
    UIImage *imageOut = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imageOut;
}

- (UIImage*)resizeToView:(UIView*)view {
    CGFloat ratio1 = self.size.width / self.size.height;
    CGFloat ratio2 = view.bounds.size.width / view.bounds.size.height;
    CGSize r;
    
        // if the image is smaller than the view it is ok
    if (self.size.width <= view.bounds.size.width && self.size.height <= view.bounds.size.height) return self;
    
        // otherwise we want to resize it
    if (ratio1 < ratio2) {
        r = CGSizeMake(view.bounds.size.height * ratio1, view.bounds.size.height);
    }
    else {
        r = CGSizeMake(view.bounds.size.width, view.bounds.size.width / ratio1);
    }
    return [self resizeToSize:r];
}
@end
