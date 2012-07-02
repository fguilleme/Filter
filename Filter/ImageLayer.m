//
//  ImageLayer.m
//  Filter
//
//  Created by François Guillemé on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageLayer.h"

@implementation ImageLayer

- (id)initWithImage:(UIImage *)im
{
    self = [super init];
    if (self) {
        _image = [CIImage imageWithCGImage:im.CGImage];
    }
    
    return self;
}

-(BOOL)setInput:(CIImage *)im {
    return NO;
}

-(BOOL)setAtAltInput:(CIImage *)im {
    return NO;
}

-(CIImage*)output {
    return _image;
}

-(NSString *)name {
    return _image == nil ? @"no image" : [NSString stringWithFormat:@"Image %.0fx%.0f", _image.extent.size.width, _image.extent.size.height];
}

-(BOOL)hasParam {
    return YES;
}

-(CGRect)extent {
    return _image.extent;
}
@end
