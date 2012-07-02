//
//  chooseFilter.h
//  Filter
//
//  Created by François Guillemé on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol chooseFilter <NSObject>
-(void)chooseFilter:(CIFilter *)filter;
-(void)chooseImage;
-(void)chooseVideo;
@end
