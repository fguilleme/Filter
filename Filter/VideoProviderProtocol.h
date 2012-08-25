//
//  VideoProviderProtocol.h
//  Filter
//
//  Created by François Guillemé on 8/25/12.
//
//

#import <Foundation/Foundation.h>

@protocol VideoProviderProtocol <NSObject>
-(void)frameReady:(CIImage*)image;
@end
