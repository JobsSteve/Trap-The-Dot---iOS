//
//  ReeCTDNode.h
//  circle the dot - ios
//
//  Created by Reeonce Zeng on 9/22/14.
//  Copyright (c) 2014 Reeonce. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum NodeType {
    normalNode,
    netNode,
    dotNode
} ReeCTDNodeType;

typedef struct {
    int x;
    int y;
} ReeCTDDotPosition;

@interface ReeCTDNode : SKShapeNode

+ (UIColor *)getNodeColorByType:(ReeCTDNodeType)type;

- (void)updatePos:(CGPoint)pos
         NodeSize:(CGSize)size
     NodePosition:(ReeCTDDotPosition)npos
         NodeType:(ReeCTDNodeType)type;

- (BOOL)clicked;

- (void)changeType: (ReeCTDNodeType) type;

@property ReeCTDDotPosition nodePos;
@property ReeCTDNodeType nodeType;

@end
