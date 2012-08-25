//
//  FilterLayer.m
//  Filter
//
//  Created by François Guillemé on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FilterLayer.h"

@implementation FilterLayer

- (id)initWithFilter:(CIFilter *)f
{
    self = [super init];
    if (self) {
        _filter = f;
        [_filter setDefaults];
    }

    return self;
}

-(BOOL)setInput:(CIImage *)im {
    NSDictionary   *att = [_filter attributes];

    if (att[@"inputImage"]) {
        [_filter setValue:im  forKey:@"inputImage"];
        return YES;
    }
    return NO;
}

-(BOOL)setAltInput:(CIImage *)im {
    NSDictionary   *att = [_filter attributes];

    if (att[@"inputBackgroundImage"]) {
        [_filter setValue:im  forKey:@"inputBackgroundImage"];
        return YES;
    }
    if (att[@"inputTargetImage"]) {
        [_filter setValue:im  forKey:@"inputTargetImage"];
        return YES;
    }
    return NO;
}

-(CIImage *)output {
    return [_filter outputImage];
}

-(NSString *)name {
    return [_filter attributes][@"CIAttributeFilterDisplayName"];
}

-(NSDictionary *)attributes {
    return _filter.attributes;
}

-(void)setValue:(id)value forKey:(NSString *)key {
    [_filter setValue:value forKey:key];
}

-(id)valueForKey:(NSString *)key {
    return [_filter valueForKey:key];
}
@end
