//
//  VideoProvider.m
//  Filter
//
//  Created by François Guillemé on 8/25/12.
//
//

#import "VideoProvider.h"

static VideoProvider *frontProvider = nil;
static VideoProvider *backProvider = nil;

@interface VideoProvider(__private)
-(id)initWithLayer:(VideoLayer*)layer orientation:(int)front;
-(void)addLayer:(VideoLayer*)layer;
-(void)removeLayer:(VideoLayer*)layer;
@end

@implementation VideoProvider
+(VideoProvider *)providerWithLayer:(VideoLayer *)layer orientation:(int)front {
    if (front && frontProvider != nil) {
        [frontProvider addLayer:layer];
        return frontProvider;
    }
    if (!front && backProvider != nil) {
        [backProvider addLayer:layer];
        return backProvider;
    }
    VideoProvider *p = [[VideoProvider alloc] initWithLayer:layer orientation:front];
    if (front)
        frontProvider = p;
    else
        backProvider = p;
    return p;
}

-(id)initWithLayer:(VideoLayer*)layer orientation:(int)front {
    self = [super init];
    
    _mirror = NO;
    _front = front;
    
    _layers = [[NSMutableArray alloc] initWithCapacity:2];
    [_layers addObject:layer];
    
    _session = [[AVCaptureSession alloc] init];
    [_session beginConfiguration];
    [_session setSessionPreset:AVCaptureSessionPreset640x480];
    
    AVCaptureDevice *camera = nil;
    
    for (AVCaptureDevice *dev in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        camera = dev;
        if (dev.position == AVCaptureDevicePositionFront && front) {
            camera = dev;
            break;
        }
        else if (dev.position == AVCaptureDevicePositionBack && !front) {
            camera = dev;
            break;
        }
    }
    NSError *error;
    input = [AVCaptureDeviceInput deviceInputWithDevice:camera error:&error];
    [_session addInput:input];
    
    output = [[AVCaptureVideoDataOutput alloc] init];
    [output setAlwaysDiscardsLateVideoFrames:YES];
    
    NSDictionary *options = @{ (id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA) };
    [output setVideoSettings:options];
    [output setSampleBufferDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
    [_session addOutput:output];
    [_session commitConfiguration];
    
    [_session startRunning];
    return self;
}

-(void)addLayer:(VideoLayer *)layer {
    [_layers addObject:layer];
}

-(void)removeLayer:(VideoLayer *)layer {
    [_layers removeObject:layer];
}

-(void)stopCamera:(VideoLayer *)layer {
    [_layers removeObject:layer];
    if (_layers.count == 0) {
        [_session stopRunning];
        _session = nil;
        if (_front)
            frontProvider  = nil;
        else
            backProvider = nil;
    }
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CVPixelBufferRef pixelBuffer = (CVPixelBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
    CIImage *image =[CIImage imageWithCVPixelBuffer:pixelBuffer];
    
    image = [image imageByApplyingTransform:CGAffineTransformMakeRotation(-M_PI/2)];
    if (_mirror) image = [image imageByApplyingTransform:CGAffineTransformMakeScale(-1, 1)];
    CGPoint origin = [image extent].origin;
    image = [image imageByApplyingTransform:CGAffineTransformMakeTranslation(-origin.x, -origin.y)];
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        for (NSObject<VideoProviderProtocol> *l in  _layers) {
            [l frameReady:image];
        }
    });
}
@end
