//
//  ReeTTDUserData.h
//  Trap The Dot
//
//  Created by Reeonce Zeng on 10/8/14.
//  Copyright (c) 2014 Reeonce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReeTTDTypes.h"

#define TOTALLEVELS 10

@interface ReeTTDUserData : NSObject

+(instancetype)getInstance;

-(void)readUserDataWithEasyLevelRange:(NSRange)easyLevelRange hardLevelRange:(NSRange)hardLevelRange;

-(NSUInteger)getMaxLevel:(ReeTTDMode)mode;

@property (nonatomic) BOOL soundOn;

@property (nonatomic) NSArray *allLevelScores;

@property (nonatomic) NSArray *easyLevelScores;

@property (nonatomic) NSArray *hardLevelScores;

@property (nonatomic) int randomModeScore;

@property (nonatomic) ReeTTDMode gameMode;

@property BOOL colorful;

@end
