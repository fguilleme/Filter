//
//  LayerList.h
//  Filter
//
//  Created by François Guillemé on 8/25/12.
//
//

#import <Foundation/Foundation.h>
#import "Layer.h"

@interface LayerList : NSObject {
    NSMutableArray *_layers;
    NSLock *_lock;
}
@property NSMutableArray *layers;

-(id)init;
-(void)lock;
-(void)unlock;
@end
