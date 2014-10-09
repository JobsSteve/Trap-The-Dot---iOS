//
//  ReeTTDNavPage.h
//  Trap The Dot !
//
//  Created by Reeonce Zeng on 9/29/14.
//  Copyright (c) 2014 Reeonce. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ReeTTDTypes.h"
#import "ReeTTDUserData.h"

@interface ReeTTDNavPage : SKSpriteNode

-(void)viewDidLoadedWithEasyScores:(NSArray *)easyLevelScores hardScores:(NSArray *)hardLevelScores randomScore:(int)randomModeScore;
-(void) updateScoresWithEasyScores:(NSArray *)easyLevelScores hardScores:(NSArray *)hardLevelScores randomScore:(int)randomModeScore;

@property (nonatomic) ReeTTDUserData *userData;

@property ReeTTDMode gameMode;
@property (readonly) int level;

@end
