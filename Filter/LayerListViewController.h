//
//  LayerListViewController.h
//  Filter
//
//  Created by François Guillemé on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "layerChooser.h"
#import "Layer.h"
#import "ImageLayer.h"
#import "FilterLayer.h"
#import "filterRefresh.h"

@interface LayerListViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView *tableView;
}
@property(strong) NSMutableArray *layers;
@property(weak) id<layerChooser,layerAction> delegate;

-(void)reload;

@end
