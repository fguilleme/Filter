//
//  UIColorPicker.h
//  Filter
//
//  Created by François Guillemé on 6/25/12.
//
//

#import <UIKit/UIKit.h>

#define NBCOL 8

@interface UIColorPicker : UIControl {
    NSArray *m_colors;
    NSMutableArray *m_views;
    int m_selection;
}
@property(retain) UIColor *color; 
@end
