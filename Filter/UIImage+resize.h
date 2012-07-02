//
//  UIImage+resize.h
//  CI3
//
//  Created by François Guillemé on 6/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (UIImage_resize)
- (UIImage*)resizeToSize:(CGSize)size;
- (UIImage*)resizeToView:(UIView*)view;
@end
