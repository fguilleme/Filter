//
//  FilteredImageView.m
//  Filter
//
//  Created by François Guillemé on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FilteredImageView.h"

#import "ImageLayer.h"
#import "VideoLayer.h"

@implementation FilteredImageView

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _context = [CIContext contextWithOptions:nil];

            // keep a list of the layers
        _layers = [[LayerList alloc] init];

        CGRect r = CGRectMake(0, self.bounds.size.height /2, self.bounds.size.width, 72);
        
        _emptyLabel = [[UILabel alloc] initWithFrame:r];
        _emptyLabel.text = @"EMPTY";
        _emptyLabel.textColor = [UIColor grayColor];
        _emptyLabel.font = [UIFont systemFontOfSize:72];
        _emptyLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_emptyLabel];
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeTop;
        _imageView.clearsContextBeforeDrawing = NO;
        _imageView.backgroundColor = [UIColor grayColor];
        [self addSubview:_imageView];
        
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activity.center = self.center;
        _activity.hidden = YES;
        [self addSubview:_activity];
        
        _emptyLabel.hidden = NO;
        _imageView.hidden = YES;
        
        sem = dispatch_semaphore_create(1);
    }
    return self;
}

-(CGImageRef)buildFilteredImage {
    CGImageRef image = nil;
    NSMutableArray  *stack = [NSMutableArray arrayWithCapacity:16];
    CGRect largest = CGRectZero;

    [_layers lock];

        // find the largest image
    for (Layer *l in _layers.layers) {
        if ([l class] == [ImageLayer class] || [l class] == [VideoLayer class]) {
            largest = CGRectUnion(largest, l.extent);
        }
    }
    
    for (Layer *l in _layers.layers) {
        if (l.enabled == NO) continue;
        
        CIImage *top = nil;
        
        if ([stack count] > 0) top = [stack lastObject];
        
        if (top != nil) {
                // try to set the input
            if ([l setInput:top]) {
                    // the filter took it so remove it from the stack
                [stack removeLastObject];
                top = nil;
            }
        }
        
            // again for the secondary input
        if ([stack count] > 0) top = [stack lastObject];
        
        if (top != nil) {
            if ([l setAltInput:top]) {
                [stack removeLastObject];
                top = nil;
            }
        }
        
            // push the result onto the stack
        top = [l output];
        if (top != nil) {
            if (CGRectIsInfinite(top.extent)) {
                CGRect r = largest;
                if (CGRectIsEmpty(r)) r = self.bounds;
                
                // we cannot deal with lazy CIImage so convert them to an ImageView size
                top = [top imageByCroppingToRect:r];
                
            }
            [stack addObject:top];
        }
    }
    
    if ([stack count] > 0) {
        CIImage *im = [stack lastObject];
        [stack removeLastObject];
        
        CGRect rect = self.bounds;
        if (!CGRectIsInfinite(im.extent)) rect = im.extent;
        image = [_context createCGImage:im fromRect:rect];
        im = nil;
    }

    // release all layers
    for (Layer *l in _layers.layers) {
        [l setAltInput:nil];
        [l setInput:nil];
    }
    [stack removeAllObjects];
    stack = nil;

    [_layers unlock];

    return image;
}

-(void)rebuildImage {
    if (dispatch_semaphore_wait(sem, DISPATCH_TIME_NOW) == 0) {
        _activity.hidden = NO;
       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            CGImageRef cg = [self buildFilteredImage];
            
            if (cg != nil) {
                UIImage *im = [UIImage imageWithCGImage:cg];
                CFRelease(cg);
                dispatch_sync(dispatch_get_main_queue(), ^{
                    _imageView.image = im;
                    _emptyLabel.hidden = YES;
                    _imageView.hidden = NO;
                    _activity.hidden = YES;
                });
            }
            else {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    _imageView.image = nil;
                    _emptyLabel.hidden = NO;
                    _imageView.hidden = YES;
                    _activity.hidden = YES;
                });
            }
            dispatch_semaphore_signal(sem);
        });
    }
}
@end
