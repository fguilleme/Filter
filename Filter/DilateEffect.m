//
//  DilateEffect.m
//  Filter
//
//  Created by François Guillemé on 8/19/12.
//
//

#import "DilateEffect.h"

@implementation DilateEffect
-(id)init {
     self = [super init];
    _width = 1;
    return self;
}

-(NSString *)name {
    return @"Dilate";
}

-(void)setValue:(id)value  forKey:(NSString*)key {
    if ([key compare:@"inputImage"] == 0) {
        image = value;
    }
    if ([key compare:@"Width"] == 0) {
        _width  = [(NSNumber*)value intValue];
    }
}

-(CIImage*)outputImage {
    short kernel[256] = { 0 };

    CIImage *im = [super dilateImage:image withKernel:kernel ofSize:_width*2+1];
    image = nil;
    return im;
    
}

-(id)valueForKey:(NSString *)key {
    if ([key compare:@"outputImage"] == 0) {
        return [self outputImage];
    }
    if ([key compare:@"Width"] == 0) {
        return @(_width);
    }
    return nil;
}

-(NSDictionary *)attributes {
    
    NSDictionary *widthDict =  @{ @"CIAttributeFilterDisplayName": @"Width",
                                    @"CIAttributeClass": @"NSNumber",
                                    @"CIAttributeSliderMin":@0,
                                    @"CIAttributeSliderMax":@3,
                                    @"DiscreteSlider": @YES
                                };
    
    return @{   @"Width" : widthDict,
                @"inputImage": @"",
                @"CIAttributeFilterDisplayName": @"Dilate"
            };
}

@end
