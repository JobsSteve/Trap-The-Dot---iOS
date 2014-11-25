//
//  ReeTTDBoard.m
//  Trap The Dot - ios
//
//  Created by Reeonce Zeng on 9/22/14.
//  Copyright (c) 2014 Reeonce. All rights reserved.
//

#import "ReeTTDBoard.h"
#import "ReeTTDNode.h"
#import "ReeQueue.h"
#include "stdlib.h"
#import "ReeTTDResultBoard.h"
#import "ReeTTDConfiguration.h"
#import "ReeTTDUserData.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MobClickGameAnalytics.h"
#import "GameScene.h"
#import "ReeTTDBoard-PlayGame.h"

const int defaultXLength = 9;
const int defaultYLength = 9;
const int defaltLevel = 0;

@implementation ReeTTDBoard {
    int originNets[100];
    int originNetsCount;
    
    int easyModeTotalLevels;
    int hardModeTotalLevels;
}

@synthesize steps = steps;
@synthesize nodeSize = nodeSize;
@synthesize x_length = x_length;
@synthesize y_length = y_length;

@synthesize gameBoard = gameBoard;

@synthesize dot_pos = dot_pos;
@synthesize gameMode = gameMode;
@synthesize currentLevel = currentLevel;

- (void)setSize: (CGSize)p_size {
    super.size = p_size;
    double boardWidth = CGRectGetWidth(self.frame);
    double boardHeight = CGRectGetHeight(self.frame);
    nodeSize.width = boardWidth / (y_length + 0.5);
    nodeSize.height = boardHeight / x_length;

    int i=0, j;
    for (NSMutableArray *row in gameBoard) {
        j=0;
        for (ReeTTDNode *node in row) {
            CGPoint p = [self getPositionByX:i Y:j];
            [node updatePos:p NodeSize:nodeSize NodePosition: node.nodePos NodeType:node.nodeType];
            
            j++;
        }
        i ++;
    }
}

- (void) renderGameWithMode:(ReeTTDMode)mode Level:(NSUInteger)level {
    self.userData = [ReeTTDUserData getInstance];
    easyModeTotalLevels = [(NSNumber *)[ReeTTDConfiguration getValueWithKey:@"EasyLevelCount"] intValue];
    hardModeTotalLevels = [(NSNumber *)[ReeTTDConfiguration getValueWithKey:@"HardLevelCount"] intValue];
    currentLevel = (int)level;
    gameMode = mode;
    int netCount;
    if (mode == ReeTTDModeRandom) {
        netCount = rand() % 15 + 4;
    } else if (mode == ReeTTDModeEasy) {
        netCount = (easyModeTotalLevels - currentLevel) * 3 + 18;
    } else if (mode == ReeTTDModeHard) {
        netCount = (hardModeTotalLevels - currentLevel) * 3 + 3;
    } else {
        netCount = 0;
    }
    
    [MobClickGameAnalytics startLevel: [self getCurrentLevelString]];
    [self renderGameWithXLen: defaultXLength YLen: defaultYLength];
    [self renderNetNodesRandWithNumber:netCount];
    
    self.gameState = ReeTTDGameStatePlaying;
}

-(BOOL)nextLevel {
    currentLevel ++;
    if ((gameMode == ReeTTDModeEasy && currentLevel > [self.userData getMaxLevel:ReeTTDModeEasy]) ||
        (gameMode == ReeTTDModeHard && currentLevel > [self.userData getMaxLevel:ReeTTDModeHard])) {
        return NO;
    } else {
        [self renderGameWithMode:gameMode Level:currentLevel];
        self.gameState = ReeTTDGameStatePlaying;
        return YES;
    }
}

-(void)retryCurrentLevel {
    [self renderGameWithMode:gameMode Level:currentLevel];
}

- (void)replayCurrentLevel {
    [self renderGameWithXLen: x_length YLen: y_length];
    [self renderNetNodesForReplay];
    self.gameState = ReeTTDGameStatePlaying;
}

- (void) renderGameWithXLen: (int)x YLen: (int)y {
    [self removeAllChildren];
    
    x_length = x;
    y_length = y;
    self.steps = 0;
    
    double boardWidth = CGRectGetWidth(self.frame);
    double boardHeight = CGRectGetHeight(self.frame);
    nodeSize.width = boardWidth / (y + 0.5);
    nodeSize.height = boardHeight / x;
    
    gameBoard = [[NSMutableArray alloc] initWithCapacity:x_length];
    for (int i=0; i<x_length; i++) {
        NSMutableArray *row = [[NSMutableArray alloc] initWithCapacity:y_length];
        for (int j=0; j<y_length; j++) {
            ReeTTDNode *sprite = [[ReeTTDNode alloc] init];
            ReeTTDDotPosition np;
            np.x = i;
            np.y = j;
            CGPoint p = [self getPositionByX:i Y:j];
            [sprite updatePos:p NodeSize:nodeSize NodePosition: np NodeType:normalNode];
            
            [self addChild:sprite];
            [row addObject:sprite];
        }
        [gameBoard addObject:row];
    }
    
    
    dot_pos.x = (x - 1) / 2;
    dot_pos.y = (y - 1) / 2;
    ReeTTDNode *sprite = [[gameBoard objectAtIndex:dot_pos.x] objectAtIndex: dot_pos.y];
    [sprite changeType:dotNode];
}

-(void)renderNetNodesRandWithNumber:(int)net_number {
    originNetsCount = net_number;
    
    srand((unsigned)time(NULL));
    int totalNodesCount = x_length * y_length - 1;
    int numbers[totalNodesCount];
    for (int i=0; i<totalNodesCount; i++) {
        numbers[i] = i;
    }
    for (int i=0; i<net_number; i++) {
        int j = rand() % (totalNodesCount - i);
        originNets[i] = numbers[j];
        numbers[j] = numbers[totalNodesCount - 1 - i];
    }
    for (int i=0; i<net_number; i++) {
        int xx = originNets[i] / y_length;
        int yy = originNets[i] % x_length;
        if (xx == dot_pos.x && yy == dot_pos.y) {
            xx = x_length - 1;
            yy = y_length - 1;
        }
        if (xx < gameBoard.count) {
            NSArray *row = [gameBoard objectAtIndex:xx];
            if (yy < row.count) {
                ReeTTDNode *sprite = [row objectAtIndex: yy];
                [sprite changeType:netNode];
            }
        }
    }
}

-(void)renderNetNodesForReplay {
    for (int i=0; i<originNetsCount; i++) {
        int xx = originNets[i] / y_length;
        int yy = originNets[i] % x_length;
        if (xx == dot_pos.x && yy == dot_pos.y) {
            xx = x_length - 1;
            yy = y_length - 1;
        }
        if (xx < gameBoard.count) {
            NSArray *row = [gameBoard objectAtIndex:xx];
            if (yy < row.count) {
                ReeTTDNode *sprite = [row objectAtIndex: yy];
                [sprite changeType:netNode];
            }
        }
    }
}

- (CGPoint)getPositionByX: (int)x Y: (int)y {
    CGPoint point;
    point.x = nodeSize.width * (y +  (x % 2) / 2.0 );
    point.y = nodeSize.height * x;
    return point;
}

-(void)gameDidEnd: (BOOL)isWin {
    GameScene *gs = (GameScene *)self.scene;
    
    if (isWin) {
        [MobClickGameAnalytics finishLevel: [self getCurrentLevelString]];
        self.gameState = ReeTTDGameStateWin;
    } else {
        [MobClickGameAnalytics failLevel: [self getCurrentLevelString]];
        self.gameState = ReeTTDGameStateLose;
    }
    
    CGRect rect = gs.view.bounds;
    rect.size.width = rect.size.height;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 1.0);
    CGRect rect1 = gs.view.bounds;
    rect1.origin.x = (rect1.size.height - rect1.size.width) / 2;
    [gs.view drawViewHierarchyInRect: rect1 afterScreenUpdates:NO];
    gs.playImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

-(NSString *) getCurrentLevelString {
    NSString * levelString;
    if (gameMode == ReeTTDModeRandom) {
        levelString = [NSString stringWithFormat: @"Random"];
    } else if (gameMode == ReeTTDModeEasy) {
        levelString = [NSString stringWithFormat: @"Easy_%d", currentLevel];
    } else {
        levelString = [NSString stringWithFormat: @"Hard_%d", currentLevel];
    }
    return levelString;
}

@end
