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

const int defaultXLength = 9;
const int defaultYLength = 9;
const int defaltLevel = 0;

@implementation ReeTTDBoard {
    CGSize nodeSize;
    int x_length;
    int y_length;
    
    NSMutableArray *gameBoard;
    
    ReeTTDDotPosition dot_pos;
    
    ReeTTDMode gameMode;
    int currentLevel;
    
    int originNets[100];
    int originNetsCount;
    
    int easyModeTotalLevels;
    int hardModeTotalLevels;
}

@synthesize steps = steps;

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
        [MobClickGameAnalytics startLevel: [NSString stringWithFormat: @"Random"]];
    } else if (mode == ReeTTDModeEasy) {
        netCount = (easyModeTotalLevels - currentLevel) * 3 + 18;
        [MobClickGameAnalytics startLevel: [NSString stringWithFormat: @"Easy: %d", currentLevel]];
    } else if (mode == ReeTTDModeHard) {
        netCount = (hardModeTotalLevels - currentLevel) * 3 + 3;
        [MobClickGameAnalytics startLevel: [NSString stringWithFormat: @"Hard: %d", currentLevel]];
    } else {
        netCount = 0;
    }
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

-(void)finishGame {
}

-(CGPoint)getPositionByX: (int)x Y: (int)y {
    CGPoint point;
    point.x = nodeSize.width * (y +  (x % 2) / 2.0 );
    point.y = nodeSize.height * x;
    return point;
}

-(ReeTTDDotPosition)getIndexByPosition: (CGPoint)pos {
    ReeTTDDotPosition p;
    p.x = pos.y / nodeSize.height;
    p.y = pos.x / nodeSize.width - (p.x % 2) / 2.0;
    p.y = p.y < 0? 0: p.y;
    p.y = p.y >= y_length? y_length-1: p.y;
    return p;
}

-(ReeTTDDotPosition)searchNext {
    ReeTTDDotPosition pos = dot_pos;
    
    ReeQueue *queue = [[ReeQueue alloc] initWithCapacity: (x_length * y_length)];
    
    ReeTTDNode *dotNode = [[gameBoard objectAtIndex:dot_pos.x] objectAtIndex: dot_pos.y];
    
    ReeTTDDotPosition step[x_length][y_length];
    int isVisited[x_length][y_length];
    for (int i=0; i<x_length; i++) {
        for (int j=0; j<y_length; j++) {
            step[i][j].x = i;
            step[i][j].y = j;
            isVisited[i][j] = 0;
        }
    }
    
    isVisited[dot_pos.x][dot_pos.y] = 1;
    for (int i=_previousDirection; i<6+_previousDirection; i++) {
        ReeTTDDirection dire = i % 6;
        ReeTTDNode *node;
        ReeTTDDotPosition p = [dotNode getPositionByDirection:dire];
        if (p.x < 0 || p.x >= x_length || p.y < 0 || p.y >= y_length) {
            return p;
        }
        isVisited[p.x][p.y] = 1;
        node = [[gameBoard objectAtIndex:p.x] objectAtIndex: p.y];
        if ([node nodeType] == normalNode) {
            [queue enQueue:node];
            pos = p;
        }
    }
    while (queue.count > 0) {
        ReeTTDNode *node = [queue deQueue];
        for (int i=_previousDirection; i<6+_previousDirection; i++) {
            ReeTTDDirection dire = i % 6;
            ReeTTDDotPosition p = [node getPositionByDirection:dire];
            if (p.x < 0 || p.x >= x_length || p.y < 0 || p.y >= y_length) {
                _previousDirection = [dotNode directionToNearbyNodePos:step[node.nodePos.x][node.nodePos.y]];
                return step[node.nodePos.x][node.nodePos.y];
            }
            if (step[p.x][p.y].x == p.x && step[p.x][p.y].y == p.y && isVisited[p.x][p.y] == 0) {
                isVisited[p.x][p.y] = 1;
                step[p.x][p.y] = step[node.nodePos.x][node.nodePos.y];
                ReeTTDNode *nearNode = [[gameBoard objectAtIndex:p.x] objectAtIndex: p.y];
                if ([nearNode nodeType] == normalNode) {
                    [queue enQueue:nearNode];
                }
                pos = step[p.x][p.y];
            }
        }
    }
    
    _previousDirection = [dotNode directionToNearbyNodePos:pos];
    return pos;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        ReeTTDDotPosition clickedNodePos = [self getIndexByPosition:[touch locationInNode:self]];
        ReeTTDNode *node;
        if (clickedNodePos.x < gameBoard.count) {
            NSArray *row = [gameBoard objectAtIndex:clickedNodePos.x];
            if (clickedNodePos.y < row.count) {
                node = [row objectAtIndex: clickedNodePos.y];
            }
        }
        if ([node clicked]) {
            self.steps ++;
            ReeTTDDotPosition nextStep = [self searchNext];
            ReeTTDNode *sprite = [[gameBoard objectAtIndex:dot_pos.x] objectAtIndex: dot_pos.y];
            [sprite changeType:normalNode];
            if (nextStep.x < 0 || nextStep.x >= x_length || nextStep.y < 0 || nextStep.y >= y_length) {
                self.gameState = ReeTTDGameStateLose;
                [MobClickGameAnalytics failLevel: [NSString stringWithFormat: @"lose %d with %d steps", currentLevel, steps]];
                [self finishGame];
            } else if (nextStep.x == dot_pos.x && nextStep.y == dot_pos.y) {
                if (gameMode == ReeTTDModeRandom) {
                    [MobClickGameAnalytics finishLevel: [NSString stringWithFormat: @"random with %d steps", steps]];
                    if (self.userData.randomModeScore < 0 || steps < self.userData.randomModeScore) {
                        self.userData.randomModeScore = steps;
                    }
                } else if (gameMode == ReeTTDModeEasy) {
                    [MobClickGameAnalytics finishLevel: [NSString stringWithFormat: @"Easy: %d with %d steps", currentLevel, steps]];
                    if (currentLevel-1 < self.userData.easyLevelScores.count) {
                        NSNumber *num = [self.userData.easyLevelScores objectAtIndex:currentLevel-1];
                        int originScore = [num intValue];
                        if (originScore < 0 || steps < originScore) {
                            NSNumber *newScore = [[NSNumber alloc] initWithInt:steps];
                            NSMutableArray *a = [NSMutableArray arrayWithArray:self.userData.easyLevelScores];
                            [a setObject:newScore atIndexedSubscript:currentLevel-1];
                            self.userData.easyLevelScores = a;
                        }

                    }
                } else if (gameMode == ReeTTDModeHard) {
                    [MobClickGameAnalytics finishLevel: [NSString stringWithFormat: @"hard: %d with %d steps", currentLevel, steps]];
                    if (currentLevel-1 < self.userData.hardLevelScores.count) {
                        NSNumber *num = [self.userData.hardLevelScores objectAtIndex:currentLevel-1];
                        int originScore = [num intValue];
                        if (originScore < 0 || steps < originScore) {
                            NSNumber *newScore = [[NSNumber alloc] initWithInt:steps];
                            NSMutableArray *a = [NSMutableArray arrayWithArray:self.userData.hardLevelScores];
                            [a setObject:newScore atIndexedSubscript:currentLevel-1];
                            self.userData.hardLevelScores = a;
                        }
                    }
                }
                self.gameState = ReeTTDGameStateWin;
                [self finishGame];
            }
            else {
                dot_pos = nextStep;
                sprite = [[gameBoard objectAtIndex:nextStep.x] objectAtIndex: nextStep.y];
                [sprite changeType:dotNode];
                [self playJumpSound];
            }
        }
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"stateOn"]) {
        BOOL changedState = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        self.soundOn = changedState;
    } else if ([keyPath isEqualToString:@"colorful"]) {
        int i=0, j;
        for (NSMutableArray *row in gameBoard) {
            j=0;
            for (ReeTTDNode *node in row) {
                [node changeType:node.nodeType];
                j++;
            }
            i ++;
        }
    }
}

-(void)playJumpSound {
    if (self.soundOn) {
        SystemSoundID soundID;
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/sound.mp3", [[NSBundle mainBundle] resourcePath]]];
        
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
        AudioServicesPlaySystemSound (soundID);
    }
}

@end
