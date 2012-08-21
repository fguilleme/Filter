//
//  EmbossEffect.h
//  Filter
//
//  Created by François Guillemé on 7/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreImage/CoreImage.h>
#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>

@interface ConvolveEffect : CIFilter {
    CIContext *_context;
}

-(CIImage *)convolveImage:(CIImage *)image withKernel:(short*)kernel ofSize:(uint32_t)size;
@end

@interface BaseDilateEffect : CIFilter {
    CIContext *_context;
}

-(CIImage *)dilateImage:(CIImage *)image withKernel:(short*)kernel ofSize:(uint32_t)size;
@end