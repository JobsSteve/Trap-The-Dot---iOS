//
//  ReeTTDBoard.h
//  Trap The Dot - ios
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
-(void)gameDidEnd: (BOOL)isWin;
-(NSString *) getCurrentLevelString;

@property double nodeWidth;
@property double nodeHeight;
@property BOOL soundOn;

@property (nonatomic) ReeTTDUserData *userData;

@property int steps;

@property ReeTTDGameState gameState;

@property (nonatomic) ReeTTDDirection previousDirection;

@property (nonatomic) CGSize nodeSize;
@property (nonatomic) int x_length;
@property (nonatomic) int y_length;
@property (nonatomic) int currentLevel;

@property (nonatomic) NSMutableArray *gameBoard;

@property (nonatomic) ReeTTDDotPosition dot_pos;

@property (nonatomic) NSMutableArray *reachableNets;
@property (nonatomic) NSArray *reachableCircle;

@property (nonatomic) ReeTTDMode gameMode;

@property (nonatomic) UIImage *playImage;

@end
