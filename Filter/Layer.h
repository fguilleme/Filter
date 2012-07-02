//
//  Layer.h
//  Filter
//
//  Created by François Guillemé on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Layer : NSObject {
    CIImage *m_passthrough;
}

@property(strong) NSString *name;
@property BOOL enabled;

-(BOOL)setInput:(CIImage *)im;
-(BOOL)setAltInput:(CIImage *)im;

-(CIImage*)output;
-(NSString*)description;
-(NSString *)name;
-(CGRect)extent;
-(NSDictionary*)attributes;
@end
