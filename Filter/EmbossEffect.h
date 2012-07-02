//
//  EmbossEffect.h
//  Filter
//
//  Created by François Guillemé on 7/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConvolveEffect.h"

@interface EmbossEffect : ConvolveEffect {
    CIImage *image;
}

@end
