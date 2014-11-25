//
//  ReeTTDBoard-PlayGame.m
//  Trap The Dot
//
//  Created by Reeonce Zeng on 11/20/14.
//  Copyright (c) 2014 Reeonce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReeTTDBoard-PlayGame.h"
#import <SpriteKit/SpriteKit.h>
#import "ReeTTDNode.h"
#import "ReeQueue.h"
#include "stdlib.h"
#import "ReeTTDResultBoard.h"
#import "ReeTTDConfiguration.h"
#import "ReeTTDUserData.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MobClickGameAnalytics.h"

@implementation ReeTTDBoard (PlayGame)

- (ReeTTDDotPosition)getIndexByPosition: (CGPoint)pos {
    ReeTTDDotPosition p;
    p.x = pos.y / self.nodeSize.height;
    p.y = pos.x / self.nodeSize.width - (p.x % 2) / 2.0;
    p.y = p.y < 0? 0: p.y;
    p.y = p.y >= self.y_length? self.y_length - 1: p.y;
    return p;
}

- (ReeTTDDotPosition)searchNext {
    self.reachableNets = [NSMutableArray array];
    
    ReeTTDDotPosition pos = self.dot_pos;
    
    ReeQueue *queue = [[ReeQueue alloc] initWithCapacity: (self.x_length * self.y_length)];
    
    ReeTTDNode *dotNode = [[self.gameBoard objectAtIndex:self.dot_pos.x] objectAtIndex: self.dot_pos.y];
    
    ReeTTDDotPosition step[self.x_length][self.y_length];
    int isVisited[self.x_length][self.y_length];
    for (int i=0; i<self.x_length; i++) {
        for (int j=0; j<self.y_length; j++) {
            step[i][j].x = i;
            step[i][j].y = j;
            isVisited[i][j] = 0;
        }
    }
    
    isVisited[self.dot_pos.x][self.dot_pos.y] = 1;
    for (int i=self.previousDirection; i<6+self.previousDirection; i++) {
        ReeTTDDirection dire = i % 6;
        ReeTTDNode *node;
        ReeTTDDotPosition p = [dotNode getPositionByDirection:dire];
        if (p.x < 0 || p.x >= self.x_length || p.y < 0 || p.y >= self.y_length) {
            return p;
        }
        isVisited[p.x][p.y] = 1;
        node = [[self.gameBoard objectAtIndex:p.x] objectAtIndex: p.y];
        if ([node nodeType] == normalNode) {
            [queue enQueue:node];
            pos = p;
        } else if ([node nodeType] == netNode) {
            [self.reachableNets addObject:node];
        }
    }
    while (queue.count > 0) {
        ReeTTDNode *node = [queue deQueue];
        for (int i=self.previousDirection; i<6+self.previousDirection; i++) {
            ReeTTDDirection dire = i % 6;
            ReeTTDDotPosition p = [node getPositionByDirection:dire];
            if (p.x < 0 || p.x >= self.x_length || p.y < 0 || p.y >= self.y_length) {
                self.previousDirection = [dotNode directionToNearbyNodePos:step[node.nodePos.x][node.nodePos.y]];
                return step[node.nodePos.x][node.nodePos.y];
            }
            if (step[p.x][p.y].x == p.x && step[p.x][p.y].y == p.y && isVisited[p.x][p.y] == 0) {
                isVisited[p.x][p.y] = 1;
                step[p.x][p.y] = step[node.nodePos.x][node.nodePos.y];
                ReeTTDNode *nearNode = [[self.gameBoard objectAtIndex:p.x] objectAtIndex: p.y];
                if ([nearNode nodeType] == normalNode) {
                    [queue enQueue:nearNode];
                }  else if ([nearNode nodeType] == netNode) {
                    [self.reachableNets addObject:nearNode];
                }
                pos = step[p.x][p.y];
            }
        }
    }
    
    self.previousDirection = [dotNode directionToNearbyNodePos:pos];
    return self.dot_pos;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        ReeTTDDotPosition clickedNodePos = [self getIndexByPosition:[touch locationInNode:self]];
        ReeTTDNode *node;
        if (clickedNodePos.x < self.gameBoard.count) {
            NSArray *row = [self.gameBoard objectAtIndex:clickedNodePos.x];
            if (clickedNodePos.y < row.count) {
                node = [row objectAtIndex: clickedNodePos.y];
            }
        }
        if ([node clicked]) {
            self.steps ++;
            ReeTTDDotPosition nextStep = [self searchNext];
            ReeTTDNode *sprite = [[self.gameBoard objectAtIndex:self.dot_pos.x] objectAtIndex: self.dot_pos.y];
            if (nextStep.x < 0 || nextStep.x >= self.x_length || nextStep.y < 0 || nextStep.y >= self.y_length) {
                [self gameWillEnd: NO];
            } else if (nextStep.x == self.dot_pos.x && nextStep.y == self.dot_pos.y) {
                [self updateScore];
                [self gameWillEnd:YES];
            }
            else {
                [sprite changeType:normalNode];
                self.dot_pos = nextStep;
                sprite = [[self.gameBoard objectAtIndex:nextStep.x] objectAtIndex: nextStep.y];
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
        for (NSMutableArray *row in self.gameBoard) {
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

- (int)getIndexNumberWithNode: (ReeTTDNode *)node {
    return node.nodePos.x * self.y_length + node.nodePos.y;
}

-(void)sortCircleNets {
    int isInCircle[100];
    for (ReeTTDNode *net in self.reachableNets) {
        isInCircle[[self getIndexNumberWithNode:net]] = 0;
    }
    
    int i = 0;
    isInCircle[[self getIndexNumberWithNode:self.reachableNets.firstObject]] = 1;
    while (i < self.reachableNets.count) {
        ReeTTDNode *node = [self.reachableNets objectAtIndex:i];
        //NSLog(@"circle at %d, %d, at index: %d", node.nodePos.x, node.nodePos.y, i);
        BOOL hasNext = NO;
        for (int d=0; d<6; d++) {
            ReeTTDDotPosition p = [node getPositionByDirection:d];
            if (p.x >= 0 && p.x < self.x_length && p.y >= 0 && p.y < self.y_length) {
                ReeTTDNode *nearNode = [[self.gameBoard objectAtIndex:p.x] objectAtIndex: p.y];
                //NSLog(@"near at %d, %d", p.x, p.y);
                NSUInteger index = [self.reachableNets indexOfObject:nearNode];
                int isInCircleForNearNode = isInCircle[[self getIndexNumberWithNode:nearNode]];
                if (index != NSNotFound && nearNode && isInCircleForNearNode == 0) {
                    [self.reachableNets setObject:[self.reachableNets objectAtIndex:i + 1] atIndexedSubscript:index];
                    [self.reachableNets setObject:nearNode atIndexedSubscript: i + 1];
                    i ++;
                    isInCircle[[self getIndexNumberWithNode:nearNode]] = 1;
                    hasNext = YES;
                    break;
                } else if (index != NSNotFound && nearNode && index < i - 4) {
                    //那么圈很可能在这里
                    int a0 = 0, a1 = 0, a2 = 0, a3 = 0;
                    for (NSUInteger c = index; c <= i; c ++) {
                        ReeTTDDotPosition pos = ((ReeTTDNode *)[self.reachableNets objectAtIndex:c]).nodePos;
                        if (pos.x == self.dot_pos.x && pos.y < self.dot_pos.y) {
                            a0 = 1;
                        } else if (pos.x == self.dot_pos.x && pos.y > self.dot_pos.y) {
                            a1 = 1;
                        }  else if (pos.x < self.dot_pos.x && pos.y == self.dot_pos.y) {
                            a2 = 1;
                        }  else if (pos.x > self.dot_pos.x && pos.y == self.dot_pos.y) {
                            a3 = 1;
                        }
                    }
                    if (a0 + a1 + a2 + a3 == 4) {
                        self.reachableCircle = [self.reachableNets subarrayWithRange: NSMakeRange(index, i + 1 - index)];
                        return;
                    }
                }
            }
        }
        if (!hasNext) {
            BOOL isDeathRoad = YES;
            int top = i;
            while (i > 0) {
                i --;
                node = [self.reachableNets objectAtIndex:i];
                
                //NSLog(@"back at %d, %d", node.nodePos.x, node.nodePos.y);
                for (int dn=0; dn<6; dn++) {
                    ReeTTDDotPosition pn = [node getPositionByDirection:dn];
                    if (pn.x >= 0 && pn.x < self.x_length && pn.y >= 0 && pn.y < self.y_length) {
                        ReeTTDNode *nearNoden = [[self.gameBoard objectAtIndex:pn.x] objectAtIndex: pn.y];
                        NSUInteger indexn = [self.reachableNets indexOfObject:nearNoden];
                        
                        int isInCircleForNearNoden = isInCircle[[self getIndexNumberWithNode:nearNoden]];
                        if (indexn != NSNotFound && nearNoden && isInCircleForNearNoden == 0) {
                            [self.reachableNets setObject:[self.reachableNets objectAtIndex:i + 1] atIndexedSubscript:indexn];
                            [self.reachableNets setObject:nearNoden atIndexedSubscript: i + 1];
                            i ++;
                            isInCircle[[self getIndexNumberWithNode:nearNoden]] = 1;
                            isDeathRoad = NO;
                            break;
                        }
                    }
                }
                if (!isDeathRoad) {
                    break;
                }
            }
            if (isDeathRoad) {
                i = top + 1;
            }
        }
    }
}

-(void)gameWillEnd:(BOOL)isWin {
    if (isWin) {
        [self sortCircleNets];
        NSArray *circle = self.reachableCircle;
        SKShapeNode *line = [SKShapeNode node];
        ReeTTDNode *node = [circle objectAtIndex:0];
        ReeTTDNode *firstNode = node;
        CGMutablePathRef pathToDraw = CGPathCreateMutable();
        //NSLog(@"circle at %d, %d", node.nodePos.x, node.nodePos.y);
        CGPathMoveToPoint(pathToDraw, NULL, CGRectGetMidX(node.frame), CGRectGetMidY(node.frame));
        for (int i = 1; i < circle.count; i ++) {
            node = [circle objectAtIndex:i];
            CGPathAddLineToPoint(pathToDraw, NULL, CGRectGetMidX(node.frame), CGRectGetMidY(node.frame));
            //NSLog(@"circle at %d, %d", node.nodePos.x, node.nodePos.y);
        }
        CGPathAddLineToPoint(pathToDraw, NULL, CGRectGetMidX(firstNode.frame), CGRectGetMidY(firstNode.frame));
        line.path = pathToDraw;
        [line setStrokeColor:[UIColor orangeColor]];
        [line setLineWidth:10];
        line.zPosition = 8;
        [self addChild:line];
        
        SKAction *followline = [SKAction followPath:pathToDraw asOffset:YES orientToPath:NO duration:2.0];
        ReeTTDNode *anode = [[ReeTTDNode alloc] initWithImageNamed:@"dot-blue"];
        anode.size = CGSizeMake(12, 12);
        anode.zPosition = 9;
        __block ReeTTDBoard *board = self;
        [anode runAction:followline completion:^{
            [board gameDidEnd:YES];
        }];
        [self addChild:anode];
    } else {
        [self gameDidEnd:NO];
    }
}

- (void)updateScore {
    if (self.gameMode == ReeTTDModeRandom) {
        if (self.userData.randomModeScore < 0 || self.steps < self.userData.randomModeScore) {
            self.userData.randomModeScore = self.steps;
        }
    } else if (self.gameMode == ReeTTDModeEasy) {
        if (self.currentLevel-1 < self.userData.easyLevelScores.count) {
            NSNumber *num = [self.userData.easyLevelScores objectAtIndex:self.currentLevel-1];
            int originScore = [num intValue];
            if (originScore < 0 || self.steps < originScore) {
                NSNumber *newScore = [[NSNumber alloc] initWithInt:self.steps];
                NSMutableArray *a = [NSMutableArray arrayWithArray:self.userData.easyLevelScores];
                [a setObject:newScore atIndexedSubscript:self.currentLevel-1];
                self.userData.easyLevelScores = a;
            }
        }
    } else if (self.gameMode == ReeTTDModeHard) {
        if (self.currentLevel-1 < self.userData.hardLevelScores.count) {
            NSNumber *num = [self.userData.hardLevelScores objectAtIndex:self.currentLevel-1];
            int originScore = [num intValue];
            if (originScore < 0 || self.steps < originScore) {
                NSNumber *newScore = [[NSNumber alloc] initWithInt:self.steps];
                NSMutableArray *a = [NSMutableArray arrayWithArray:self.userData.hardLevelScores];
                [a setObject:newScore atIndexedSubscript:self.currentLevel-1];
                self.userData.hardLevelScores = a;
            }
        }
    }
}

@end
