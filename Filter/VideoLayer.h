//
//  VideoLayer.h
//  Filter
//
//  Created by François Guillemé on 6/30/12.
//
//
#import <AVFoundation/AVFoundation.h>

#import "Layer.h"
#import "FilterViewController.h"
#import "VideoProviderProtocol.h"
#import "VideoProvider.h"

@interface VideoLayer : Layer<VideoProviderProtocol> {
    VideoProvider *_provider;
    CIImage *_image;
    
    FilteredImageView *_view;

}
-(id)initWithView:(FilteredImageView*)view;
@end
