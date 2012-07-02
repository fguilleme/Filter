//
//  FilteredImageView.h
//  Filter
//
//  Created by François Guillemé on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Layer.h"

@interface FilteredImageView : UIView {
    CIContext *_context;
    NSInteger _currentLayer;
    UILabel *_emptyLabel;
    UIImage *_image;
}

@property(strong) NSMutableArray *layers;
@property(strong) UIImageView *imageView;
@end
