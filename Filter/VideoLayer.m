//
//  VideoLayer.m
//  Filter
//
//  Created by François Guillemé on 6/30/12.
//
//

#import "VideoLayer.h"

@implementation VideoLayer

-(void) setupCamera:(BOOL)front {
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
    
    _mirror = YES;
}

-(void) stopCamera {
    [_session stopRunning];
//    [_session beginConfiguration];
//    [_session removeInput:input];
//    [_session removeOutput:output];
//    [_session commitConfiguration];
//    input = nil;
//    output = nil;
    _session = nil;
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CVPixelBufferRef pixelBuffer = (CVPixelBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
    CIImage *image =[CIImage imageWithCVPixelBuffer:pixelBuffer];
    
    image = [image imageByApplyingTransform:CGAffineTransformMakeRotation(-M_PI/2)];
    if (_mirror) image = [image imageByApplyingTransform:CGAffineTransformMakeScale(-1, 1)];
    CGPoint origin = [image extent].origin;
    image = [image imageByApplyingTransform:CGAffineTransformMakeTranslation(-origin.x, -origin.y)];
   
    dispatch_sync(dispatch_get_main_queue(), ^{
        _image = image;
        [_view setNeedsDisplay];
    });
}

- (id)initWithView:(UIView*)view {
    self = [super init];
    if (self) {
        _front = YES;
        [self setupCamera:_front];
        _view = view;
    }
    return self;
}

-(BOOL)setInput:(CIImage *)im {
    return NO;
}

-(BOOL)setAtAltInput:(CIImage *)im {
    return NO;
}

-(CIImage*)output {
    return _image;
}

-(NSString *)name {
    return @"Video input";
}

-(CGRect)extent {
    return _image.extent;
}

-(NSDictionary *)attributes {
    NSDictionary *mirrorDict = @{   @"CIAttributeFilterDisplayName": @"Mirror",
                                    @"CIAttributeClass": @"NSBool",
    };
    NSDictionary *frontDict = @{    @"CIAttributeFilterDisplayName": @"Front",
                                    @"CIAttributeClass": @"NSBool",
    };
    return @{   @"Mirror" : mirrorDict,
                @"Front" : frontDict,
                @"inputImage": @"",
                @"CIAttributeFilterDisplayName": @"Video capture"
    };
}

-(void)setValue:(id)value forKey:(NSString *)key {
    if ([key compare:@"Mirror"] == 0) {
        _mirror = [(NSNumber*)value boolValue];
    }
    else if ([key compare:@"Front"] == 0) {
        [self stopCamera];
        _front = [(NSNumber*)value boolValue];
        [self setupCamera:_front];
    }
}

-(id)valueForKey:(NSString *)key {
    if ([key compare:@"Mirror"] == 0) {
        return @(_mirror);
    }
    else if ([key compare:@"Front"] == 0) {
        return @(_front);
    }    return nil;
}
@end
