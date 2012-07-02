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
    if ([super initWithCoder:aDecoder]) {
        _context = [CIContext contextWithOptions:nil];

            // keep a list of the layers
        _layers = [NSMutableArray arrayWithCapacity:16];

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
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGImageRef cg = [self buildFilteredImage];
    if (cg == nil ) {
        _imageView.hidden = YES;
        _imageView.image = nil;
        
        _emptyLabel.hidden = NO;
    }
    else {
        _imageView.image = [UIImage imageWithCGImage:cg];
        CFRelease(cg);
        _imageView.hidden = NO;
        _emptyLabel.hidden = YES;
    }
 }

-(CGImageRef)buildFilteredImage {
    CGImageRef image = nil;
    NSMutableArray  *stack = [NSMutableArray arrayWithCapacity:16];
    CGRect largest = CGRectZero;
    
        // find the largest image
    for (Layer *l in _layers) {
        if ([l class] == [ImageLayer class] || [l class] == [VideoLayer class]) {
            largest = CGRectUnion(largest, l.extent);
        }
    }
    
    for (Layer *l in _layers) {
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
                
                // we cannot deal with lazi CIImage so convert them to an ImageView size
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
    }

    // release all layers
    for (Layer *l in _layers) {
        [l setAltInput:nil];
        [l setInput:nil];
    }
    [stack removeAllObjects];
    stack = nil;
    
    return image;
}
@end
