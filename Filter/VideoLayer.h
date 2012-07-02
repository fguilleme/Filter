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

@interface VideoLayer : Layer<AVCaptureVideoDataOutputSampleBufferDelegate> {
    AVCaptureSession *_session;
    AVCaptureDeviceInput *input;
    AVCaptureVideoDataOutput *output;
    CIImage *_image;
    UIView *_view;
    bool _mirror;
    bool _front;
}
-(id)initWithView:(UIView*)view;
@end
