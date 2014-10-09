//
//  ReeTTDBoard.h
//  circle the dot - ios
//
//  Created by Reeonce Zeng on 9/22/14.
//  Copyright (c) 2014 Reeonce. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ReeTTDTypes.h"
#import "ReeTTDUserData.h"


@interface ReeTTDBoard : SKSpriteNode

-(void)renderGameWithMode:(ReeTTDMode)mode Level:(NSUInteger)level;
-(BOOL)nextLevel;
-(void)retryCurrentLevel;
-(void)replayCurrentLevel;
-(void)finishGame;

@property double nodeWidth;
@property double nodeHeight;
@property BOOL soundOn;

@property (nonatomic) ReeTTDUserData *userData;

@property int steps;

@property ReeTTDGameState gameState;

@property (readonly, nonatomic) ReeTTDDirection previousDirection;

@end
