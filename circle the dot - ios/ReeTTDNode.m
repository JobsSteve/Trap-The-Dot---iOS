//
//  ReeTTDNode.m
//  circle the dot - ios
//
//  Created by Reeonce Zeng on 9/22/14.
//  Copyright (c) 2014 Reeonce. All rights reserved.
//

#import "ReeTTDNode.h"


@implementation ReeTTDNode

- (void) updatePos:(CGPoint)pos
          NodeSize:(CGSize)size
      NodePosition:(ReeTTDDotPosition)npos
          NodeType:(ReeTTDNodeType)type {
    _nodeType = type;
    _nodePos = npos;
    self.anchorPoint = CGPointMake(0, 0);
    self.position = pos;
    self.size = CGSizeMake(size.height, size.height);
    self.texture = [ReeTTDNode getNodeTextureByType:type];
}

-(BOOL)clicked {
    switch (_nodeType) {
        case dotNode:
            break;
        case normalNode:
            _nodeType = netNode;
            self.texture = [ReeTTDNode getNodeTextureByType:_nodeType];
            return true;
        case netNode:
            break;
        default:
            break;
    }
    return false;
}

- (void)changeType: (ReeTTDNodeType) type {
    _nodeType = type;
    self.texture = [ReeTTDNode getNodeTextureByType:type];
}

SKTexture *dotTexture;
SKTexture *netTexture;
SKTexture *nodeTexture;
SKTexture *dotColorfulTexture;
SKTexture *netColorfulTexture;
SKTexture *nodeColorfulTexture;
+ (SKTexture *) getNodeTextureByType:(ReeTTDNodeType)type {
    if (!dotTexture || !netTexture || !nodeTexture) {
        dotColorfulTexture = [SKTexture textureWithImageNamed:@"dot-blue"];
        netColorfulTexture = [SKTexture textureWithImageNamed:@"net-yellow"];
        nodeColorfulTexture = [SKTexture textureWithImageNamed:@"node-gray-d"];
        dotTexture = [SKTexture textureWithImageNamed:@"dot-node"];
        netTexture = [SKTexture textureWithImageNamed:@"net-node"];
        nodeTexture = [SKTexture textureWithImageNamed:@"node-gray"];
    }
    if ([ReeTTDUserData getInstance].colorful) {
        switch (type) {
            case dotNode:
                return dotColorfulTexture;
            case netNode:
                return netColorfulTexture;
            default:
                return nodeColorfulTexture;
        }
    } else {
        switch (type) {
            case dotNode:
                return dotTexture;
            case netNode:
                return netTexture;
            default:
                return nodeTexture;
        }
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"colorful"]) {
        //self.texture = nil;
        self.texture = [ReeTTDNode getNodeTextureByType:_nodeType];
    }
}


-(ReeTTDDotPosition)getPositionByDirection: (ReeTTDDirection)direction {
    ReeTTDDotPosition result;
    switch (direction) {
        case ReeTTDDirectionLeftUp:
            result.x = _nodePos.x + 1;
            result.y = _nodePos.y - (_nodePos.x + 1) % 2;
            break;
        case ReeTTDDirectionLeft:
            result.x = _nodePos.x;
            result.y = _nodePos.y - 1;
            break;
        case ReeTTDDirectionLeftDown:
            result.x = _nodePos.x - 1;
            result.y = _nodePos.y - (_nodePos.x + 1) % 2;
            break;
        case ReeTTDDirectionRightUp:
            result.x = _nodePos.x + 1;
            result.y = _nodePos.y + _nodePos.x % 2;
            break;
        case ReeTTDDirectionRight:
            result.x = _nodePos.x;
            result.y = _nodePos.y + 1;
            break;
        case ReeTTDDirectionRightDown:
            result.x = _nodePos.x - 1;
            result.y = _nodePos.y + _nodePos.x % 2;
            break;
        default:
            break;
    }
    return result;
}

-(ReeTTDDirection)directionToNearbyNodePos:(ReeTTDDotPosition)pos {
    if (pos.x == _nodePos.x + 1 && pos.y == _nodePos.y - (_nodePos.x + 1) % 2) {
        return ReeTTDDirectionLeftUp;
    } else if (pos.x == _nodePos.x && pos.y == _nodePos.y - 1) {
        return ReeTTDDirectionLeft;
    } else if (pos.x == _nodePos.x - 1 && pos.y == _nodePos.y - (_nodePos.x + 1) % 2) {
        return ReeTTDDirectionLeftDown;
    } else if (pos.x == _nodePos.x + 1 && pos.y == _nodePos.y + _nodePos.x % 2) {
        return ReeTTDDirectionRightUp;
    } else if (pos.x == _nodePos.x && pos.y == _nodePos.y + 1) {
        return ReeTTDDirectionRight;
    } else {
        return ReeTTDDirectionRightDown;
    }
}

@end
