//
//  EdgeEffect.m
//  Filter
//
//  Created by François Guillemé on 7/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EdgeEffect.h"

@implementation EdgeEffect

-(NSString *)name {
    return @"Edge";
}

-(void)setValue:(id)value  forKey:(NSString*)key {
    if ([key compare:@"inputImage"] == 0) {
        image = value;
    }  
}

-(CIImage*)outputImage {
    static short kernel[] = {
        -1, -1, -1,
        0, 0, 0,
        1, 1, 1
    };
    CIImage *im = [super convolveImage:image withKernel:kernel ofSize:3];
    image = nil;
    return im;
    
}

-(id)valueForKey:(NSString *)key {
    if ([key compare:@"outputImage"] == 0) {
        return [self outputImage];
    }
    return nil;
}

-(NSDictionary *)attributes {
    return @{ @"inputImage": @"",
              @"CIAttributeFilterDisplayName": @"Edge"
            };

}

@end
