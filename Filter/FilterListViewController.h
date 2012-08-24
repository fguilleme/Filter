//
//  FilterListViewControler.h
//  Filter
//
//  Created by François Guillemé on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "chooseFilter.h"
#import "BlurEffect.h"
#import "EmbossEffect.h"
#import "EdgeEffect.h"
#import "DilateEffect.h"
#import "BlackAndWhite.h"

#import "OpenCVBlur.h"
#import "OpenCVCanny.h"
#import "OpenCVErode.h"
#import "OpenCVHough.h"

@interface FilterListViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *filters;
    NSArray *effects;
    NSArray *opencv;
}
@property(weak) id<chooseFilter> delegate;

@end
