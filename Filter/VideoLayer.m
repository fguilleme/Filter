//
//  VideoLayer.m
//  Filter
//
//  Created by François Guillemé on 6/30/12.
//
//

#import "VideoLayer.h"

@implementation VideoLayer

- (id)initWithView:(FilteredImageView*)view {
    self = [super init];
    if (self) {
        _provider = [VideoProvider providerWithLayer:self orientation:YES];
        _provider.mirror = YES;
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
        _provider.mirror = [(NSNumber*)value boolValue];
    }
    else if ([key compare:@"Front"] == 0) {
        bool front = [(NSNumber*)value boolValue];
        bool mirror = _provider.mirror;
        
        [_provider stopCamera:self];
        _provider = [VideoProvider providerWithLayer:self orientation:front];
        if (front) _provider.mirror = mirror;
    }
}

-(id)valueForKey:(NSString *)key {
    if ([key compare:@"Mirror"] == 0) {
        return @(_provider.mirror);
    }
    else if ([key compare:@"Front"] == 0) {
        return @(_provider.front);
    }
    return nil;
}

-(void)frameReady:(CIImage *)image {
    if (self.enabled == NO) return;
    
    _image = image;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_view rebuildImage];
    });
}
-(void)finish {
    [_provider stopCamera:self];
}
@end
