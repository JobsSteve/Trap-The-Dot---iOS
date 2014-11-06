//
//  GameScene.h
//  Trap The Dot - ios
//

//  Copyright (c) 2014年 Reeonce. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ReeTTDTypes.h"
#import "ReeTTDUserData.h"
#import "ReeTTDBoard.h"
#import "ReeTTDResultBoard.h"
#import "ReeTTDNavPage.h"

@interface GameScene : SKScene

-(void)showResult: (ReeTTDResult)result stepsUsed:(int)steps;
- (void)removeResultLabel;
- (void)updateSteps: (int)steps;
- (void)doRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
- (void)rotateToLandscape;
- (void)rotateToPortrait;
-(void)nextLevel;
-(void)retryCurrentLevel;
-(void)replayGame;
-(void)changeGameMode;
-(void)switchToRandomMode;
-(void)switchToChallengeModeWithMode:(ReeTTDMode)mode Level: (int)level;

@property (nonatomic) UIInterfaceOrientation preferredInterfaceOrientationForPresentation;

@property (nonatomic) ReeTTDUserData *userData;

@property (nonatomic) ReeTTDBoard *gameBoard;


@property (nonatomic) SKLabelNode *gameTitleLabel;

@property (nonatomic) SKLabelNode *gameResultLabel;

@property (nonatomic) ReeTTDResultBoard *resultBoard;

@property (nonatomic) ReeTTDNavPage *navPage;

@property (nonatomic) SKSpriteNode *replayButton;

@property (nonatomic) SKSpriteNode *nextPlayButton;

@end
