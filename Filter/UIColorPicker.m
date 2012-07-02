//
//  UIColorPicker.m
//  Filter
//
//  Created by François Guillemé on 6/25/12.
//
//

#import "UIColorPicker.h"

@implementation UIColorPicker

- (void)clickHandler:(id)sender {
    UIButton *b = sender;
    self.color = [m_colors objectAtIndex:b.tag];
    b.tintColor = self.color;

    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    // hack to restore the button color
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        b.highlighted = YES;
    });
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        m_colors = @[[UIColor blackColor], [UIColor whiteColor], [UIColor blueColor], [UIColor greenColor], [UIColor redColor], [UIColor orangeColor], [UIColor cyanColor], [UIColor purpleColor]];
        m_views = [NSMutableArray arrayWithCapacity:[m_colors count]];
        
        float pad = 2;
        CGRect r = CGRectMake(pad, pad, frame.size.height - pad * 2, frame.size.height - 2 * pad);
        
        [m_colors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CGRect rr = r;
            UIColor *c = obj;
            UIButton *b = [UIButton buttonWithType:UIButtonTypeRoundedRect];

            rr.origin.x = idx * frame.size.height;
            b.frame = rr;
            b.tintColor = c;
            b.tag = idx;
            b.highlighted = YES;
            [b addTarget:self action:@selector(clickHandler:) forControlEvents:UIControlEventTouchUpInside];

            [self addSubview:b];
            [m_views addObject:b];

        }];
    }
    return self;
}
@end
