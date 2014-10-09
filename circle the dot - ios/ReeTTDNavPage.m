//
//  ReeTTDNavPage.m
//  Trap The Dot !
//
//  Created by Reeonce Zeng on 9/29/14.
//  Copyright (c) 2014 Reeonce. All rights reserved.
//

#import "ReeTTDNavPage.h"
#import "ReeTTDButton.h"
#import "ReeTTDLevelNode.h"
#import "ReeTTDLevelsBoard.h"

@implementation ReeTTDNavPage {
    ReeTTDLevelNode *randomModeButton;
    ReeTTDLevelsBoard *easyLevelsBoard;
    ReeTTDLevelsBoard *hardLevelsBoard;
}

-(void)viewDidLoadedWithEasyScores:(NSArray *)easyLevelScores hardScores:(NSArray *)hardLevelScores randomScore:(int)randomModeScore {
    self.userData = [ReeTTDUserData getInstance];
    self.anchorPoint = CGPointZero;
    self.zPosition = 99;
    
    SKLabelNode *randomModeLable = [SKLabelNode labelNodeWithFontNamed:@""];
    randomModeLable.text = NSLocalizedString(@"RANDOM_MODE", @"Random Mode");
    randomModeLable.position = CGPointMake(CGRectGetMidX(self.frame), 560);
    
    SKSpriteNode *randomModeLableBg = [SKSpriteNode spriteNodeWithColor:self.color size:CGSizeMake(320, 30)];
    randomModeLableBg.position = CGPointMake(CGRectGetMidX(self.frame), 560);
    
    SKShapeNode *randomLine = [[SKShapeNode alloc] init];
    CGPoint leftPoint = CGPointMake(0, 570);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, leftPoint.x, leftPoint.y);
    CGPathAddLineToPoint(path, nil, CGRectGetMaxX(self.frame), 570);
    randomLine.path = path;
    randomLine.lineWidth = 0.1;
    
    if (randomModeScore < 0) {
        randomModeButton = [ReeTTDLevelNode levelNodeWithSize:CGSizeMake(100, 100) backgroudColor:[SKColor colorWithWhite:0.8 alpha:0.8] fontColor:[SKColor colorWithWhite:0.2 alpha:1.0] levelScore:randomModeScore isFadeInOut:YES];
    } else {
        randomModeButton = [ReeTTDLevelNode levelNodeWithSize:CGSizeMake(100, 100) backgroudColor:[SKColor colorWithWhite:0.8 alpha:0.8] fontColor:[SKColor colorWithWhite:0.2 alpha:1.0] levelScore:randomModeScore isFadeInOut:NO];
    }
    randomModeButton.position = CGPointMake(CGRectGetMidX(self.frame) - 60, 430);
    
    [self addChild:randomLine];
    [self addChild:randomModeLableBg];
    [self addChild:randomModeLable];
    [self addChild:randomModeButton];
    
    
    SKLabelNode *challengeModeEasyLable = [SKLabelNode labelNodeWithFontNamed:@""];
    challengeModeEasyLable.text = NSLocalizedString(@"EASY_MODE", @"Easy Mode");
    challengeModeEasyLable.position = CGPointMake(CGRectGetMidX(self.frame), 370);
    
    SKSpriteNode *challengeModeEasyLableBg = [SKSpriteNode spriteNodeWithColor:self.color size:CGSizeMake(320, 30)];
    challengeModeEasyLableBg.position = CGPointMake(CGRectGetMidX(self.frame), 370);
    
    SKShapeNode *challengeModeEasyLine = [[SKShapeNode alloc] init];
    CGPoint cLeftPoint = CGPointMake(0, 380);
    CGMutablePathRef cPath = CGPathCreateMutable();
    CGPathMoveToPoint(cPath, nil, cLeftPoint.x, cLeftPoint.y);
    CGPathAddLineToPoint(cPath, nil, CGRectGetMaxX(self.frame), 380);
    challengeModeEasyLine.path = cPath;
    challengeModeEasyLine.lineWidth = 0.1;
    
    [self addChild:challengeModeEasyLine];
    [self addChild:challengeModeEasyLableBg];
    [self addChild:challengeModeEasyLable];
    
    easyLevelsBoard = [[ReeTTDLevelsBoard alloc] init];
    easyLevelsBoard.position = CGPointMake(CGRectGetMidX(self.frame) - 200, 260);
    easyLevelsBoard.size = CGSizeMake(400, 230);
    [easyLevelsBoard viewDidLoaded: easyLevelScores];
    [self addChild:easyLevelsBoard];
    
    SKLabelNode *challengeModeHardLable = [SKLabelNode labelNodeWithFontNamed:@""];
    challengeModeHardLable.text = NSLocalizedString(@"HARD_MODE", @"Hard Mode");
    challengeModeHardLable.position = CGPointMake(CGRectGetMidX(self.frame), 210);
    
    SKSpriteNode *challengeModeHardLableBg = [SKSpriteNode spriteNodeWithColor:self.color size:CGSizeMake(320, 30)];
    challengeModeHardLableBg.position = CGPointMake(CGRectGetMidX(self.frame), 210);
    
    SKShapeNode *challengeModeHardLine = [[SKShapeNode alloc] init];
    CGPoint hLeftPoint = CGPointMake(0, 220);
    CGMutablePathRef hPath = CGPathCreateMutable();
    CGPathMoveToPoint(hPath, nil, hLeftPoint.x, hLeftPoint.y);
    CGPathAddLineToPoint(hPath, nil, CGRectGetMaxX(self.frame), 220);
    challengeModeHardLine.path = hPath;
    challengeModeHardLine.lineWidth = 0.1;
    
    [self addChild:challengeModeHardLine];
    [self addChild:challengeModeHardLableBg];
    [self addChild:challengeModeHardLable];
    
    hardLevelsBoard = [[ReeTTDLevelsBoard alloc] init];
    hardLevelsBoard.position = CGPointMake(CGRectGetMidX(self.frame) - 200, 100);
    hardLevelsBoard.size = CGSizeMake(320, 230);
    [hardLevelsBoard viewDidLoaded: hardLevelScores];
    [self addChild:hardLevelsBoard];
}

-(void) updateScoresWithEasyScores:(NSArray *)easyLevelScores hardScores:(NSArray *)hardLevelScores randomScore:(int)randomModeScore {
    if (randomModeScore < 0) {
        [randomModeButton updateScore:randomModeScore isFadeInOut:YES];
    } else {
        [randomModeButton updateScore:randomModeScore isFadeInOut:NO];
    }
    [easyLevelsBoard updateScores: easyLevelScores];
    [hardLevelsBoard updateScores: hardLevelScores];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        NSArray *touchNodes = [self nodesAtPoint:[touch locationInNode:self]];
        for (SKNode *node in touchNodes) {
            if (node.self == randomModeButton) {
                [self removeFromParent];
                self.gameMode = ReeTTDModeRandom;
                return;
            }
        }
    }
    
    int level = [easyLevelsBoard touchesBegan:touches withEvent:event];
    if (level > 0 && level <= [self.userData getMaxLevel:ReeTTDModeEasy]) {
        [self removeFromParent];
        _level = level;
        self.gameMode = ReeTTDModeEasy;
        return;
    }
    
    level = [hardLevelsBoard touchesBegan:touches withEvent:event];
    if (level > 0 && level <= [self.userData getMaxLevel:ReeTTDModeHard]) {
        [self removeFromParent];
        _level = level;
        self.gameMode = ReeTTDModeHard;
    }
}

@end
