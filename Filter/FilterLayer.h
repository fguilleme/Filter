//
//  FilterLayer.h
//  Filter
//
//  Created by François Guillemé on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Layer.h"

@interface FilterLayer : Layer {
    CIFilter *_filter;
}
-(id)initWithFilter:(CIFilter*)f;
-(void)setValue:(id)value forKey:(NSString *)key;
-(id)valueForKey:(NSString *)key;
@end
