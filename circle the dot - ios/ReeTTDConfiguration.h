//
//  ReeTTDConfiguration.h
//  Trap The Dot !
//
//  Created by Reeonce Zeng on 9/26/14.
//  Copyright (c) 2014 Reeonce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReeTTDConfiguration : NSObject

+ (NSObject *)getValueWithKey: (NSString *)key;
+(NSRange)getEasyLevelRange;
+(NSRange)getHardLevelRange;

@end
