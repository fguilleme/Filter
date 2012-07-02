//
//  Layer.m
//  Filter
//
//  Created by François Guillemé on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Layer.h"

@implementation Layer

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
        _enabled = YES;
        m_passthrough = nil;
    }
    return self;
}

-(BOOL)setInput:(CIImage *)im {
    return NO;
}

-(BOOL)setAltInput:(CIImage *)im {
    return NO;
}

-(CIImage*)output {
    return nil;
}

-(NSString*) description {
    return _name;
}


-(CGRect)extent {
    return CGRectZero;
}

-(NSDictionary *)attributes {
    return nil;
}
@end
