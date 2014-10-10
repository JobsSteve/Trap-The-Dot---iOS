//
//  ReeTTDNode.h
//  Trap The Dot - ios
//
//  Created by Reeonce Zeng on 9/22/14.
//  Copyright (c) 2014 Reeonce. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ReeTTDTypes.h"
#import "ReeTTDUserData.h"

@interface ReeTTDNode : SKSpriteNode

- (void)updatePos:(CGPoint)pos
         NodeSize:(CGSize)size
     NodePosition:(ReeTTDDotPosition)npos
         NodeType:(ReeTTDNodeType)type;

- (BOOL)clicked;

- (void)changeType: (ReeTTDNodeType) type;

-(ReeTTDDotPosition)getPositionByDirection: (ReeTTDDirection)direction;

-(ReeTTDDirection)directionToNearbyNodePos:(ReeTTDDotPosition)pos;

@property ReeTTDDotPosition nodePos;
@property ReeTTDNodeType nodeType;

@end
