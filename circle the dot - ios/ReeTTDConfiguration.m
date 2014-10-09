//
//  ReeTTDConfiguration.m
//  Trap The Dot !
//
//  Created by Reeonce Zeng on 9/26/14.
//  Copyright (c) 2014 Reeonce. All rights reserved.
//

#import "ReeTTDConfiguration.h"

@implementation ReeTTDConfiguration

NSMutableDictionary *dict;

+ (NSObject *)getValueWithKey: (NSString *)key {
    if (!dict) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ReeTTDConfiguration" ofType:@"plist"];
        dict =  [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    }
    return [dict objectForKey:key];
}

static NSRange easyLevelRange = { .location = NSUIntegerMax, .length = 0};
+(NSRange)getEasyLevelRange {
    if (easyLevelRange.location == NSUIntegerMax) {
        NSNumber *easyLevelBase = (NSNumber *)[ReeTTDConfiguration getValueWithKey:@"EasyLevelBase"];
        NSNumber *easyLevelCount = (NSNumber *)[ReeTTDConfiguration getValueWithKey:@"EasyLevelCount"];
        easyLevelRange = NSMakeRange([easyLevelBase intValue], [easyLevelCount intValue]);
    }
    return easyLevelRange;
}

static NSRange hardLevelRange = { .location = NSUIntegerMax, .length = -1};
+(NSRange)getHardLevelRange {
    if (hardLevelRange.location == NSUIntegerMax) {
        NSNumber *hardLevelBase = (NSNumber *)[ReeTTDConfiguration getValueWithKey:@"HardLevelBase"];
        NSNumber *hardLevelCount = (NSNumber *)[ReeTTDConfiguration getValueWithKey:@"HardLevelCount"];
        hardLevelRange = NSMakeRange([hardLevelBase intValue], [hardLevelCount intValue]);
    }
    return hardLevelRange;
}

@end
