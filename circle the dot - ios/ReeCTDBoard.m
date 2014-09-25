//
//  ReeCTDBoard.m
//  circle the dot - ios
//
//  Created by Reeonce Zeng on 9/22/14.
//  Copyright (c) 2014 Reeonce. All rights reserved.
//

#import "ReeCTDBoard.h"
#import "ReeCTDNode.h"
#import "ReeQueue.h"
#import "GameScene.h"
#include "stdlib.h"

const int defaultXLength = 9;
const int defaultYLength = 9;
const int defaultDotNumber = 1;

@implementation ReeCTDBoard {
    CGSize nodeSize;
    int x_length;
    int y_length;
    int dot_number;
    int steps;
    
    NSMutableArray *gameBoard;
    
    ReeCTDDotPosition dot_pos;

}

- (void)setSize: (CGSize)p_size {
    super.size = p_size;
    
    double boardWidth = CGRectGetWidth(self.frame);
    double boardHeight = CGRectGetHeight(self.frame);
    nodeSize.width = boardWidth / (y_length + 0.5);
    nodeSize.height = boardHeight / x_length;

    int i=0, j;
    for (NSMutableArray *row in gameBoard) {
        j=0;
        for (ReeCTDNode *node in row) {
            CGPoint p = [self getPositionByX:i Y:j];
            [node updatePos:p NodeSize:nodeSize NodePosition: node.nodePos NodeType:node.nodeType];
            
            j++;
        }
        i ++;
    }
}

- (void) renderGame {
    [self renderGameWithXLen: defaultXLength YLen: defaultYLength DotNumber:defaultDotNumber];
}

- (void) renderGameWithXLen: (int)x YLen: (int)y DotNumber: (int)dot_number {
    [self removeAllChildren];
    x_length = x;
    y_length = y;
    steps = 0;
    
    double boardWidth = CGRectGetWidth(self.frame);
    double boardHeight = CGRectGetHeight(self.frame);
    nodeSize.width = boardWidth / (y + 0.5);
    nodeSize.height = boardHeight / x;
    
    gameBoard = [[NSMutableArray alloc] initWithCapacity:x_length];
    for (int i=0; i<x_length; i++) {
        NSMutableArray *row = [[NSMutableArray alloc] initWithCapacity:y_length];
        for (int j=0; j<y_length; j++) {
            ReeCTDNode *sprite = [[ReeCTDNode alloc] init];
            ReeCTDDotPosition np;
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
    ReeCTDNode *sprite = [[gameBoard objectAtIndex:dot_pos.x] objectAtIndex: dot_pos.y];
    [sprite changeType:dotNode];
    
    srand((unsigned)time(NULL));
    int netCount = rand() % 6 + 8;
    for (int i=0; i<netCount; i++) {
        int r = rand()%(x_length * y_length);
        int xx = r / y_length;
        int yy = r % x_length;
        if (xx == dot_pos.x && yy == dot_pos.y) {
            i--;
        } else {
            sprite = [[gameBoard objectAtIndex:xx] objectAtIndex: yy];
            [sprite changeType:netNode];
        }
    }
    
}

-(void)clicked: (CGPoint)pos {
    ReeCTDDotPosition clickedNodePos = [self getIndexByPosition:pos];
    ReeCTDNode *node = [[gameBoard objectAtIndex:clickedNodePos.x] objectAtIndex: clickedNodePos.y];
    if ([node clicked]) {
        ReeCTDDotPosition nextStep = [self searchNext];
        ReeCTDNode *sprite = [[gameBoard objectAtIndex:dot_pos.x] objectAtIndex: dot_pos.y];
        [sprite changeType:normalNode];
        if (nextStep.x < 0 || nextStep.x >= x_length || nextStep.y < 0 || nextStep.y >= y_length) {
            GameScene *gs = (GameScene *)[self parent];
            [gs lose];
            [self renderGame];
        } else if (nextStep.x == dot_pos.x && nextStep.y == dot_pos.y) {
            steps++;
            GameScene *gs = (GameScene *)[self parent];
            [gs win: steps];
            [self renderGame];
        }
        else {
            dot_pos = nextStep;
            sprite = [[gameBoard objectAtIndex:nextStep.x] objectAtIndex: nextStep.y];
            [sprite changeType:dotNode];
            steps++;
            GameScene *gs = (GameScene *)[self parent];
            [gs updateSteps:steps];
        }
    }
}

-(CGPoint)getPositionByX: (int)x Y: (int)y {
    CGPoint point;
    point.x = nodeSize.width * (y +  (x % 2) / 2.0 );
    point.y = nodeSize.height * x;
    return point;
}

-(ReeCTDDotPosition)getIndexByPosition: (CGPoint)pos {
    ReeCTDDotPosition p;
    p.x = pos.y / nodeSize.height;
    p.y = pos.x / nodeSize.width - (p.x % 2) / 2.0;
    p.y = p.y < 0? 0: p.y;
    p.y = p.y >= y_length? y_length-1: p.y;
    return p;
}

-(ReeCTDDotPosition)searchNext {
    ReeCTDDotPosition pos = dot_pos;
    
    ReeQueue *que = [[ReeQueue alloc] initWithCapacity: (x_length * y_length)];
    [que enQueue: [[gameBoard objectAtIndex:dot_pos.x] objectAtIndex: dot_pos.y]];
    ReeCTDDotPosition step[x_length][y_length];
    int isVisited[x_length][y_length];
    for (int i=0; i<x_length; i++) {
        for (int j=0; j<y_length; j++) {
            step[i][j].x = i;
            step[i][j].y = j;
            isVisited[i][j] = 0;
        }
    }
    
    isVisited[dot_pos.x][dot_pos.y] = 1;
    ReeCTDDotPosition p = [self getPositionByDirection:leftUp OriginPosition:dot_pos];
    if (p.x < 0 || p.x >= x_length || p.y < 0 || p.y >= y_length) {
        return p;
    }
    isVisited[p.x][p.y] = 1;
    ReeCTDNode *n_left_up = [[gameBoard objectAtIndex:p.x] objectAtIndex: p.y];
    if ([n_left_up nodeType] == normalNode) {
        [que enQueue:n_left_up];
        pos = p;
    }
    
    p = [self getPositionByDirection:left OriginPosition:dot_pos];
    if (p.x < 0 || p.x >= x_length || p.y < 0 || p.y >= y_length) {
        return p;
    }
    isVisited[p.x][p.y] = 1;
    ReeCTDNode *n_left = [[gameBoard objectAtIndex:p.x] objectAtIndex: p.y];
    if ([n_left nodeType] == normalNode) {
        [que enQueue:n_left];
        pos = p;
    }
    
    p = [self getPositionByDirection:leftDown OriginPosition:dot_pos];
    if (p.x < 0 || p.x >= x_length || p.y < 0 || p.y >= y_length) {
        return p;
    }
    isVisited[p.x][p.y] = 1;
    ReeCTDNode *n_left_down = [[gameBoard objectAtIndex:p.x] objectAtIndex: p.y];
    if ([n_left_down nodeType] == normalNode) {
        [que enQueue:n_left_down];
        pos = p;
    }
    
    p = [self getPositionByDirection:rightUp OriginPosition:dot_pos];
    if (p.x < 0 || p.x >= x_length || p.y < 0 || p.y >= y_length) {
        return p;
    }
    isVisited[p.x][p.y] = 1;
    ReeCTDNode *n_right_up = [[gameBoard objectAtIndex:p.x] objectAtIndex: p.y];
    if ([n_right_up nodeType] == normalNode) {
        [que enQueue:n_right_up];
        pos = p;
    }
    
    p = [self getPositionByDirection:right OriginPosition:dot_pos];
    if (p.x < 0 || p.x >= x_length || p.y < 0 || p.y >= y_length) {
        return p;
    }
    isVisited[p.x][p.y] = 1;
    ReeCTDNode *n_right = [[gameBoard objectAtIndex:p.x] objectAtIndex: p.y];
    if ([n_right nodeType] == normalNode) {
        [que enQueue:n_right];
        pos = p;
    }
    
    p = [self getPositionByDirection:rightDown OriginPosition:dot_pos];
    if (p.x < 0 || p.x >= x_length || p.y < 0 || p.y >= y_length) {
        return p;
    }
    isVisited[p.x][p.y] = 1;
    ReeCTDNode *n_right_down = [[gameBoard objectAtIndex:p.x] objectAtIndex: p.y];
    if ([n_right_down nodeType] == normalNode) {
        [que enQueue:n_right_down];
        pos = p;
    }
    
    while (que.count > 0) {
        ReeCTDNode *node = [que deQueue];
        
        p = [self getPositionByDirection:leftUp OriginPosition:node.nodePos];
        if (p.x < 0 || p.x >= x_length || p.y < 0 || p.y >= y_length) {
            return step[node.nodePos.x][node.nodePos.y];
        }
        if (step[p.x][p.y].x == p.x && step[p.x][p.y].y == p.y && isVisited[p.x][p.y] == 0) {
            isVisited[p.x][p.y] = 1;
            step[p.x][p.y] = step[node.nodePos.x][node.nodePos.y];
            n_left_up = [[gameBoard objectAtIndex:p.x] objectAtIndex: p.y];
            if ([n_left_up nodeType] == normalNode) {
                [que enQueue:n_left_up];
            }
        }
        
        p = [self getPositionByDirection:left OriginPosition:node.nodePos];
        if (p.x < 0 || p.x >= x_length || p.y < 0 || p.y >= y_length) {
            return step[node.nodePos.x][node.nodePos.y];
        }
        if (step[p.x][p.y].x == p.x && step[p.x][p.y].y == p.y && isVisited[p.x][p.y] == 0) {
            isVisited[p.x][p.y] = 1;
            step[p.x][p.y] = step[node.nodePos.x][node.nodePos.y];
            n_left = [[gameBoard objectAtIndex:p.x] objectAtIndex: p.y];
            if ([n_left nodeType] == normalNode) {
                [que enQueue:n_left];
            }
        }
        
        p = [self getPositionByDirection:leftDown OriginPosition:node.nodePos];
        if (p.x < 0 || p.x >= x_length || p.y < 0 || p.y >= y_length) {
            return step[node.nodePos.x][node.nodePos.y];
        }
        if (step[p.x][p.y].x == p.x && step[p.x][p.y].y == p.y && isVisited[p.x][p.y] == 0) {
            isVisited[p.x][p.y] = 1;
            step[p.x][p.y] = step[node.nodePos.x][node.nodePos.y];
            n_left_down = [[gameBoard objectAtIndex:p.x] objectAtIndex: p.y];
            if ([n_left_down nodeType] == normalNode) {
                [que enQueue:n_left_down];
            }
        }
        
        p = [self getPositionByDirection:rightUp OriginPosition:node.nodePos];
        if (p.x < 0 || p.x >= x_length || p.y < 0 || p.y >= y_length) {
            return step[node.nodePos.x][node.nodePos.y];
        }
        if (step[p.x][p.y].x == p.x && step[p.x][p.y].y == p.y && isVisited[p.x][p.y] == 0) {
            isVisited[p.x][p.y] = 1;
            step[p.x][p.y] = step[node.nodePos.x][node.nodePos.y];
            n_right_up = [[gameBoard objectAtIndex:p.x] objectAtIndex: p.y];
            if ([n_right_up nodeType] == normalNode) {
                [que enQueue:n_right_up];
            }
        }
        
        p = [self getPositionByDirection:right OriginPosition:node.nodePos];
        if (p.x < 0 || p.x >= x_length || p.y < 0 || p.y >= y_length) {
            return step[node.nodePos.x][node.nodePos.y];
        }
        if (step[p.x][p.y].x == p.x && step[p.x][p.y].y == p.y && isVisited[p.x][p.y] == 0) {
            isVisited[p.x][p.y] = 1;
            step[p.x][p.y] = step[node.nodePos.x][node.nodePos.y];
            n_right = [[gameBoard objectAtIndex:p.x] objectAtIndex: p.y];
            if ([n_right nodeType] == normalNode) {
                [que enQueue:n_right];
            }
        }
        
        p = [self getPositionByDirection:rightDown OriginPosition:node.nodePos];
        if (p.x < 0 || p.x >= x_length || p.y < 0 || p.y >= y_length) {
            return step[node.nodePos.x][node.nodePos.y];
        }
        if (step[p.x][p.y].x == p.x && step[p.x][p.y].y == p.y && isVisited[p.x][p.y] == 0) {
            isVisited[p.x][p.y] = 1;
            step[p.x][p.y] = step[node.nodePos.x][node.nodePos.y];
            n_right_down = [[gameBoard objectAtIndex:p.x] objectAtIndex: p.y];
            if ([n_right_down nodeType] == normalNode) {
                [que enQueue:n_right_down];
            }
        }
    }
    
    return pos;
}

-(ReeCTDDotPosition)getPositionByDirection: (ReeCTDDirection)direction OriginPosition:(ReeCTDDotPosition)pos {
    ReeCTDDotPosition result;
    switch (direction) {
        case leftUp:
            result.x = pos.x - 1;
            result.y = pos.y - (pos.x + 1) % 2;
            break;
        case left:
            result.x = pos.x;
            result.y = pos.y - 1;
            break;
        case leftDown:
            result.x = pos.x + 1;
            result.y = pos.y - (pos.x + 1) % 2;
            break;
        case rightUp:
            result.x = pos.x - 1;
            result.y = pos.y + pos.x % 2;
            break;
        case right:
            result.x = pos.x;
            result.y = pos.y + 1;
            break;
        case rightDown:
            result.x = pos.x + 1;
            result.y = pos.y + pos.x % 2;
            break;
        default:
            break;
    }
    return result;
}

@end
