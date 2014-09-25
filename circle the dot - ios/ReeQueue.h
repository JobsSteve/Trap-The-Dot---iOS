//
//  ReeQueue.h
//  circle the dot - ios
//
//  Created by Reeonce Zeng on 9/24/14.
//  Copyright (c) 2014 Reeonce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReeQueue : NSObject

-(id)init;
-(id) initWithCapacity: (NSUInteger) num;

-(void) enQueue: (id)obj;
-(id) deQueue;

@property (readonly, getter=count) NSUInteger count;

@end
