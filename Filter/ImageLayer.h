//
//  ImageLayer.h
//  Filter
//
//  Created by François Guillemé on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Layer.h"

@interface ImageLayer : Layer {
    CIImage *_image;
}

-(id)initWithImage:(UIImage*)im;
@end
