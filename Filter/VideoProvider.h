//
//  VideoProvider.h
//  Filter
//
//  Created by François Guillemé on 8/25/12.
//
//

#import <AVFoundation/AVFoundation.h>
#import "VideoProviderProtocol.h"

@class VideoLayer;

@interface VideoProvider : NSObject<AVCaptureVideoDataOutputSampleBufferDelegate> {
    AVCaptureSession *_session;
    AVCaptureDeviceInput *input;
    AVCaptureVideoDataOutput *output;
    
    NSMutableArray *_layers;
}

@property bool mirror;
@property bool front;

+(VideoProvider *)providerWithLayer:(VideoLayer*)layer orientation:(int)front;
-(void)stopCamera:(VideoLayer *)layer;
@end
