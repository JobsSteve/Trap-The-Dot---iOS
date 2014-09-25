//
//  ReeCTDBoard.h
//  circle the dot - ios
//
//  Created by Reeonce Zeng on 9/22/14.
//  Copyright (c) 2014 Reeonce. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum {
    leftUp, left, leftDown, rightUp, right, rightDown
} ReeCTDDirection;

@interface ReeCTDBoard : SKSpriteNode

- (void) renderGame;
- (void) clicked: (CGPoint)pos;

@property double nodeWidth;
@property double nodeHeight;

@end
