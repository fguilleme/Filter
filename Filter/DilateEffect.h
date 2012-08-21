//
//  DilateEffect.h
//  Filter
//
//  Created by François Guillemé on 8/19/12.
//
//

#import "ConvolveEffect.h"

@interface DilateEffect : BaseDilateEffect {
    CIImage *image;
    NSInteger _width;
}

@end
