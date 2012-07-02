//
//  filterDetailViewController.h
//  Filter
//
//  Created by François Guillemé on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "filterRefresh.h"
#import "FilterLayer.h"

@interface filterDetailViewController : UIViewController {
    FilterLayer *_layer;
    NSMutableArray *_tags;
    int m_tag;
}

@property(weak) id<layerAction> delegate;

-(id)initWithLayer:(Layer *)layer;
@end
