//
//  LayerList.m
//  Filter
//
//  Created by François Guillemé on 8/25/12.
//
//

#import "LayerList.h"

@implementation LayerList

-(id)init {
    self = [super init];
    _layers =  [[NSMutableArray  alloc] initWithCapacity:32];
    _lock = [[NSLock alloc] init];
    return self;
}

- (void)lock {
    [_lock lock];
}

- (void)unlock {
    [_lock unlock];
}

@end
