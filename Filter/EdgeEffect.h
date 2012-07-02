//
//  EdgeEffect.h
//  Filter
//
//  Created by François Guillemé on 7/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConvolveEffect.h"

@interface EdgeEffect : ConvolveEffect {
    CIImage *image;
}

@end
