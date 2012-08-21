//
//  FilterViewController.h
//  Filter
//
//  Created by François Guillemé on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilteredImageView.h"
#import "FilterListViewController.h"
#import "chooseFilter.h"
#import "LayerListViewController.h"
#import "filterDetailViewController.h"
#import "ImageLayer.h"
#import "FilterLayer.h"
#import "VideoLayer.h"
#import "UIImage+resize.h"

@interface FilterViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, chooseFilter, layerChooser, layerAction>  {
    LayerListViewController *layerListController;
    UINavigationController *layerNavigationController;
    UIImagePickerController *photoPickerController;
    UIPopoverController *picturePopover, *filterListPopover, *layerPopover;
    
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UIButton *layerButton;
    IBOutlet FilteredImageView *imageView;
    
    int currentLayer;
}

@end
