//
//  ReeQueue.m
//  circle the dot - ios
//
//  Created by Reeonce Zeng on 9/24/14.
//  Copyright (c) 2014 Reeonce. All rights reserved.
//

#import "ReeQueue.h"

@implementation ReeQueue {
    NSMutableArray *array;
}

-(id)init {
    self = [super init];
    if (self) {
        array = [[NSMutableArray alloc] init];
    }
    
    return self;
}


-(id) initWithCapacity: (NSUInteger) num{
    self = [super init];
    if (self) {
        array = [[NSMutableArray alloc] initWithCapacity:num];
    }
    
    return self;
}

-(NSUInteger) count{
    return array.count;
}

-(void) enQueue: (id)obj {
    [array addObject:obj];
}

-(id) deQueue {
    if (array.count > 0) {
        id obj = [array objectAtIndex:0];
        [array removeObjectAtIndex:0];
        return obj;
    }
    return nil;
}

@end
