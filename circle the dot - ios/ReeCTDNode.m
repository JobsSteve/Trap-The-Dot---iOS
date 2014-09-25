//
//  ReeCTDNode.m
//  circle the dot - ios
//
//  Created by Reeonce Zeng on 9/22/14.
//  Copyright (c) 2014 Reeonce. All rights reserved.
//

#import "ReeCTDNode.h"


@implementation ReeCTDNode

- (void) updatePos:(CGPoint)pos
          NodeSize:(CGSize)size
      NodePosition:(ReeCTDDotPosition)npos
          NodeType:(ReeCTDNodeType)type {
    _nodeType = type;
    _nodePos = npos;
    self.position = pos;
    CGMutablePathRef myPath = CGPathCreateMutable();
    CGPathAddEllipseInRect(myPath, nil, CGRectMake(0, 0, size.height, size.height));
    self.path = myPath;
    self.lineWidth = 0;
    self.fillColor = [ReeCTDNode getNodeColorByType:type];
}

-(BOOL)clicked {
    switch (_nodeType) {
        case dotNode:
            break;
        case normalNode:
            _nodeType = netNode;
            self.fillColor = [ReeCTDNode getNodeColorByType:netNode];
            return true;
        case netNode:
            break;
        default:
            break;
    }
    return false;
}

- (void)changeType: (ReeCTDNodeType) type {
    _nodeType = type;
    self.fillColor = [SKColor clearColor];
    self.fillColor = [ReeCTDNode getNodeColorByType:type];
}

+ (UIColor *) getNodeColorByType:(ReeCTDNodeType)type {
    switch (type) {
        case dotNode:
            return [UIColor colorWithRed:0 green:200 blue:200 alpha:1.0];
        case netNode:
            return [UIColor colorWithRed:200 green:200 blue:0 alpha:1.0];
        default:
            return [UIColor colorWithWhite:0.4 alpha:1.0];
    }
}

@end
