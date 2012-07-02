//
//  EmbossEffect.m
//  Filter
//
//  Created by François Guillemé on 7/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EmbossEffect.h"

@implementation EmbossEffect

-(NSString *)name {
    return @"Emboss";
}

-(void)setValue:(id)value  forKey:(NSString*)key {
    if ([key compare:@"inputImage"] == 0) {
        image = value;
    }  
}

-(CIImage*)outputImage {
    static short kernel[] = {
        -2, -1, 0,
        -1, 1, 1,
        0, 1, 2
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
              @"CIAttributeFilterDisplayName": @"Emboss"
            };
//    return [NSDictionary dictionaryWithObjects:@[@"", @"Emboss"]
//                                       forKeys:@[@"inputImage", @"CIAttributeFilterDisplayName"]
//            ];
}
@end
