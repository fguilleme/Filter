
    
    
    
    //
//  FilterViewController.m
//  Filter
//
//  Created by François Guillemé on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FilterViewController.h"

@implementation FilterViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    // Build the popover for the image picker
    // ======================================
    photoPickerController = [[UIImagePickerController alloc] init];
    photoPickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    photoPickerController.delegate=self;
    picturePopover = [[UIPopoverController alloc] initWithContentViewController:photoPickerController];
    
    // Build the popover for the filter list
    // =====================================
    FilterListViewController *filterListViewController = [[FilterListViewController alloc] init];
    filterListViewController.delegate = self;

    // create a navigation controller for the title
    UINavigationController *filterNavigationController = [[UINavigationController alloc] initWithRootViewController:filterListViewController];
    
    filterListPopover = [[UIPopoverController alloc] initWithContentViewController:filterNavigationController];
    filterListViewController.contentSizeForViewInPopover = CGSizeMake(320, 320);
    filterListViewController.title = @"Add layer";

    // Build the popover for the layer list
    // ====================================
    layerListController = [[LayerListViewController alloc] init];
    layerListController.layers = imageView.layers;
    layerListController.delegate = self;
    layerListController.contentSizeForViewInPopover = CGSizeMake(320, 320);
    layerListController.title = @"Layers";

    // create a navigation controller for the title and get to the filter settings when the user tap on it
    layerNavigationController = [[UINavigationController alloc] initWithRootViewController:layerListController];

    layerPopover = [[UIPopoverController alloc] initWithContentViewController:layerNavigationController];
}

- (void)viewDidUnload
{
    imageView = nil;
    layerButton = nil;
    activityIndicator = nil;
    [super viewDidUnload];
}

// called when the user has chosen a picture
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image= [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // resize the image to the view size
    image = [image resizeToView:imageView];

    // replace the first layer
    ImageLayer *layer = [[ImageLayer alloc] initWithImage:image];
    [imageView.layers lock];
    [imageView.layers.layers replaceObjectAtIndex:currentLayer withObject:layer];
    [imageView.layers unlock];

    [layerListController reload];
   
    [picturePopover dismissPopoverAnimated:NO];
    
    // redraw
    [self refresh];
}

-(void)refresh {
    [imageView rebuildImage];
}

// called when the user taps on the "Layers" button
- (IBAction)chooseLayer:(id)sender {
    [layerPopover presentPopoverFromRect:((UIView *)sender).bounds 
                                    inView:sender
                  permittedArrowDirections:UIPopoverArrowDirectionAny
                                  animated:YES];   
}

// called when the user taps on the "Add filter" button

- (IBAction)addFilter:(id)sender {
    [filterListPopover presentPopoverFromRect:((UIView *)sender).bounds 
                                       inView:sender
                     permittedArrowDirections:UIPopoverArrowDirectionAny
                                     animated:YES];   
}

-(void)addNewLayer {
    [self addFilter:layerListController.view];
}

// called when the user taps in a filter in the list
-(void)chooseFilter:(CIFilter *)filter {
    [filterListPopover dismissPopoverAnimated:YES];

        [imageView.layers lock];
        [imageView.layers.layers addObject:[[FilterLayer alloc] initWithFilter:filter]];
        [imageView.layers unlock];

        [layerListController reload];
    
    // redraw
    [self refresh];
    
    [layerPopover presentPopoverFromRect:layerButton.bounds 
                                   inView:layerButton
                 permittedArrowDirections:UIPopoverArrowDirectionAny
                                 animated:YES];  
}

-(void)chooseImage {
    [filterListPopover dismissPopoverAnimated:YES];

    [imageView.layers lock];
    currentLayer = [imageView.layers.layers count];
    [imageView.layers.layers addObject:[[ImageLayer alloc] initWithImage:nil]];
    [imageView.layers unlock];

    [layerListController reload];

    [layerPopover presentPopoverFromRect:layerButton.bounds 
                                  inView:layerButton 
                permittedArrowDirections:UIPopoverArrowDirectionAny 
                                animated:YES];
    
    [picturePopover presentPopoverFromRect:layerPopover.contentViewController.view.bounds
                                    inView:layerPopover.contentViewController.view
                  permittedArrowDirections:UIPopoverArrowDirectionAny
                                  animated:YES];   
}

-(void)chooseVideo {
    [imageView.layers lock];
    [imageView.layers.layers addObject:[[VideoLayer alloc] initWithView:imageView]];
    [imageView.layers unlock];

    [layerListController reload];
    [filterListPopover dismissPopoverAnimated:YES];
}

// called when th user taps on a layer item  in the list
-(void)editLayer:(int)index {
  [imageView.layers lock];

   if ([[imageView.layers.layers objectAtIndex:index] class] == [ImageLayer class]) {
        currentLayer = index;
        [picturePopover presentPopoverFromRect:layerPopover.contentViewController.view.bounds
                                        inView:layerPopover.contentViewController.view
                      permittedArrowDirections:UIPopoverArrowDirectionAny
                                      animated:YES];             
    }
    else {
        FilterLayer *theLayer = [imageView.layers.layers objectAtIndex:index];
        filterDetailViewController *flc = [[filterDetailViewController alloc] initWithLayer:theLayer];
        flc.delegate = self;
        flc.contentSizeForViewInPopover = CGSizeMake(320, 320);
        
        [layerNavigationController pushViewController:flc animated:YES];
    }
    [imageView.layers unlock];
}
@end
