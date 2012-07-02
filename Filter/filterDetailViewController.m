//
//  filterDetailViewController.m
//  Filter
//
//  Created by François Guillemé on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "filterDetailViewController.h"
#import "UIColorPicker.h"

@implementation filterDetailViewController
@synthesize delegate;

- (id)initWithLayer:(Layer *)layer
{
    self = [super init];
    if (self) {
        // Initialization code here.
        _layer = (FilterLayer *)layer;
        _tags = [[NSMutableArray alloc] initWithCapacity:16];
    }
    
    return self;
}

-(void)changedEnabled:(id)sender {
    UISwitch *sw = (UISwitch *)sender;
    
    _layer.enabled = sw.on;
    if (delegate != nil)
        [delegate refresh];
}

-(void)changedSwitch:(id)sender {
    UISwitch *slider = sender;
    NSString *param = [_tags objectAtIndex:slider.tag];
    [_layer setValue:@(slider.on) forKey:param];
    if (delegate != nil)
        [delegate refresh];
}

-(void)changedSlider:(id)sender {
    UISlider *slider = sender;
    NSString *param = [_tags objectAtIndex:slider.tag];
    [_layer setValue:@(slider.value) forKey:param];
    if (delegate != nil)
        [delegate refresh];
}

-(void)changedColor:(id)sender {
    UIColorPicker *picker = sender;
    NSString *param = [_tags objectAtIndex:picker.tag];
    [_layer setValue:[CIColor colorWithCGColor:picker.color.CGColor] forKey:param];
    if (delegate != nil)
        [delegate refresh];
}

- (float)createValueControl:(NSString *)fullkey param:(NSDictionary *)param rect:(CGRect)r type:(NSString *)type {
    float h = 64;
    UIView *v = nil;
    NSString *key = fullkey;
 
    CGRect rcontrol = CGRectOffset(r, 0, 24); rcontrol.size.height -= 24; r.size.height = 24;

    if ([type compare:@"NSNumber"] == 0) {
        id value = [_layer valueForKey:key];
        float minimumValue = [[param objectForKey:@"CIAttributeSliderMin"] floatValue];
        float maximumValue = [[param objectForKey:@"CIAttributeSliderMax"] floatValue];
               
        UISlider *slider = [[UISlider alloc] initWithFrame:rcontrol];
        slider.minimumValue = minimumValue;
        slider.maximumValue = maximumValue;

        slider.value = [value floatValue];
        [slider addTarget:self action:@selector(changedSlider:) forControlEvents:UIControlEventValueChanged];
        if ([param objectForKey:@"DiscreteSlider"] != nil) {
            slider.continuous = NO;
        }
        slider.tag = m_tag++;
        [_tags addObject:key];
        v = slider;
    
    }
    else if ([type compare:@"CIColor"] == 0) {
        UIColorPicker *picker = [[UIColorPicker alloc] initWithFrame:rcontrol];
        [picker addTarget:self action:@selector(changedColor:) forControlEvents:UIControlEventValueChanged];
        picker.tag = m_tag++;
        [_tags addObject:key];
        v = picker;
    }
    else if ([type compare:@"NSBool"] == 0) {
        UISwitch *sw = [[UISwitch alloc] initWithFrame:rcontrol];
        [sw addTarget:self action:@selector(changedSwitch:) forControlEvents:UIControlEventValueChanged];
        sw.on = [[_layer valueForKey:key] boolValue];
        sw.tag = m_tag++;
        [_tags addObject:key];
        v = sw;
    }
    else {
        UILabel *label = [[UILabel alloc] initWithFrame:rcontrol];
        label.text = [NSString stringWithFormat:@"%@ not implemented", type];
        label.textColor = [UIColor grayColor];
        v = label;
    }
    
    if (v != nil) {
        UILabel *label =[[UILabel alloc] initWithFrame:r];
        label.text = key;
        
        [self.view addSubview:label];
        [self.view addSubview:v];
        h = 80;
    }
    return h;
}

- (float)createControls:(NSString *)k param:(NSDictionary *)param rect:(CGRect)r {
    NSLog(@"Property %@ %@", k, param);
    if ([k compare:@"CIAttributeFilterCategories"] == 0 ||
        [k compare:@"CIAttributeFilterDisplayName"] == 0 ||
        [k compare:@"CIAttributeFilterName"] == 0 ||
        [k compare:@"inputImage"] == 0 ||
        [k compare:@"inputBackgroundImage"] == 0 ||
        [k compare:@"inputTargetImage"] == 0 ||
        [k compare:@"CIAttributeFilterDisplayName"] == 0) return 0.0;
    
    NSString *type = [param objectForKey:@"CIAttributeClass"];
        
    return [self createValueControl:k param:param rect:r type:type];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *filterParameters = [_layer attributes];

    self.title = [filterParameters objectForKey:@"CIAttributeFilterDisplayName"];

    // build the view to configure the filter
    UIScrollView *view = [[UIScrollView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.scrollEnabled = YES;
    self.view = view;
  
    CGRect rect = CGRectMake(0, 0, 320, 64);
    rect = CGRectOffset(rect, 8, 8); rect.size.width -= 8; rect.size.height -= 8;
    
    m_tag = 0;
    
    // ad an enabled switch
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 16)];
    label.text = @"Enabled";
    [self.view addSubview:label];
    rect = CGRectOffset(rect, 0, 24);
    UISwitch *sw = [[UISwitch alloc] initWithFrame:rect];
    [sw addTarget:self action:@selector(changedEnabled:) forControlEvents:UIControlEventValueChanged];
    sw.on = _layer.enabled;
    sw.onTintColor = [UIColor greenColor];

    [self.view addSubview:sw];
    rect = CGRectOffset(rect, 0, 32);

    for (NSString *parameterName in [filterParameters keyEnumerator]) {
        id parameterAttributes = [filterParameters objectForKey:parameterName];
        rect.origin.y += [self createControls:parameterName param:parameterAttributes rect:rect];
    }
    view.contentSize = CGSizeMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
}

@end
