//
//  LayerListViewController.m
//  Filter
//
//  Created by François Guillemé on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LayerListViewController.h"

@implementation LayerListViewController

-(void)editLayerList {
    if (tableView.editing) {
        [tableView setEditing:NO animated:YES];
        self.navigationItem.rightBarButtonItem.title = @"edit";    
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }
    else {
        [tableView setEditing:YES animated:YES];
        self.navigationItem.rightBarButtonItem.title = @"done";
        self.navigationItem.leftBarButtonItem.enabled = NO;

    }
}

-(void)addNewLayer {
    [_delegate addNewLayer]; 
}

-(void)viewDidLoad {
    [super viewDidLoad];
        
    tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]
                                                          style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(addNewLayer)];
    self.navigationItem.leftBarButtonItem = b;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView reloadData];
    
    self.view = tableView;
}

-(void)reload {
    [tableView setEditing:NO animated:NO];

    UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithTitle:@"edit" style:UIBarButtonItemStylePlain target:self action:@selector(editLayerList)];
    self.navigationItem.rightBarButtonItem = b;
    self.navigationItem.leftBarButtonItem.enabled = YES;
     
    [tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_layers.layers count];
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"LayerCell";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    Layer *layer = [_layers.layers objectAtIndex:indexPath.row];
    cell.textLabel.text = layer.name;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate != nil) {
        [_delegate editLayer:indexPath.row];
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [_layers lock];
    Layer *l =[_layers.layers objectAtIndex:indexPath.row];
    [l finish];
    [_layers.layers removeObjectAtIndex:indexPath.row];
    [_layers unlock];

    [tv deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    
    if (_delegate != nil) {
        [_delegate refresh];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tv moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    [_layers lock];
    Layer *l =[_layers.layers objectAtIndex:fromIndexPath.row];
    [_layers.layers removeObjectAtIndex:fromIndexPath.row];
        
    if (toIndexPath.row >= [_layers.layers count]) {
        [_layers.layers addObject:l];
    }
    else {
        NSInteger correction = 0;
        if (fromIndexPath.row < toIndexPath.row) correction = 1;
        [_layers.layers insertObject:l  atIndex:toIndexPath.row - correction];
    }
    [_layers unlock];

    if (_delegate != nil) {
        [_delegate refresh];
    }
}
@end
