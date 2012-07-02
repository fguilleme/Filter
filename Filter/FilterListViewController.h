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

@interface FilterListViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *filters;
    NSArray *effects;
}
@property(weak) id<chooseFilter> delegate;

@end
