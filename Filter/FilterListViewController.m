//
//  FilterListViewControler.m
//  Filter
//
//  Created by François Guillemé on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FilterListViewController.h"

@implementation FilterListViewController


- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]
                                                          style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    tableView.delegate = self;
    tableView.dataSource = self;
    
    self.view = tableView;

        // filters is a list of strings
    filters = [NSMutableArray arrayWithArray:[CIFilter filterNamesInCategory:kCICategoryBuiltIn]];
    
        // Remove a few not easy to use filters
    [filters removeObject:@"CIColorCube"];
    [filters removeObject:@"CIAffineClamp"];
    [filters removeObject:@"CIAffineTransform"];
    [filters removeObject:@"CIAffineTile"];
    
        // effects is a list of filters
    effects = @[[[BlurEffect alloc] init],
                [[EmbossEffect alloc] init],
                [[EdgeEffect alloc] init]
              ];
    
    [tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
    case 0:
        return 2;
    case 1:
        return [effects count];
    default:
        return [filters count];
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger) section {
    switch (section) {
    case 0:
        return @"Images/Video";
    case 1:
        return @"Effects";
    default:
        return @"Filters";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"filterList";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    
    switch (indexPath.section) {
    case 0:
        if (indexPath.row == 0)
             cell.textLabel.text = @"Choose image...";
        else if (indexPath.row == 1)
            cell.textLabel.text = @"Video capture";
        break;
    case 1:
        cell.textLabel.text = ((CIFilter*)effects[indexPath.row]).name;
        cell.textLabel.textColor = [UIColor brownColor];
        break;
    case 2:
        cell.textLabel.text = [[[CIFilter filterWithName:filters[indexPath.row]] attributes] objectForKey:@"CIAttributeFilterDisplayName"];
        cell.textLabel.textColor = [UIColor blueColor];
        break;
    }
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate != nil) {
        switch (indexPath.section) {
            case 0:
                if (indexPath.row == 0)
                    [_delegate chooseImage];
                else if (indexPath.row == 1)
                    [_delegate chooseVideo];
                break;
            case 1: 
                [_delegate chooseFilter:effects[indexPath.row]]; 
                break;
            case 2:  {
                    CIFilter *filter = [CIFilter filterWithName:filters[indexPath.row]];
                    if (filter != nil) {
                        [filter setDefaults];
                        [_delegate chooseFilter:filter];
                    }
                }
                break;
        }
    }
    return indexPath;
}


@end
