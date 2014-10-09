//
//  ReeTTDLevelNode.m
//  Trap The Dot
//
//  Created by Reeonce Zeng on 9/30/14.
//  Copyright (c) 2014 Reeonce. All rights reserved.
//

#import "ReeTTDLevelNode.h"

@implementation ReeTTDLevelNode

+(instancetype)levelNodeWithSize:(CGSize)nodeSize backgroudColor:(SKColor *)backgroundColor fontColor:(SKColor *)fontColor levelScore:(int)score isFadeInOut:(BOOL)fadeInOut {
    ReeTTDLevelNode *node = [[ReeTTDLevelNode alloc] initWithColor:[SKColor colorWithWhite:0 alpha:0] size:nodeSize];
    
    node.score = score;
    
    SKShapeNode *roundCircle = [[SKShapeNode alloc] init];
    roundCircle.path = CGPathCreateWithRoundedRect(CGRectMake(0, 0, nodeSize.width, nodeSize.height), nodeSize.width * 0.1, nodeSize.width * 0.1, nil);
    roundCircle.fillColor = fontColor;
    
    SKShapeNode *innerRoundCircle = [[SKShapeNode alloc] init];
    innerRoundCircle.path = CGPathCreateWithRoundedRect(CGRectMake(0, 0, nodeSize.width * 0.6, nodeSize.height * 0.6), nodeSize.width * 0.1, nodeSize.width * 0.1, nil);
    innerRoundCircle.fillColor = backgroundColor;
    innerRoundCircle.position = CGPointMake(nodeSize.width * 0.2, nodeSize.height * 0.2);
    
    node.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@""];
    if (score < 0) {
        node.scoreLabel.text = @"?";
    } else {
        node.scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)score];
    }
    node.scoreLabel.fontColor = fontColor;
    node.scoreLabel.fontSize = nodeSize.height * 0.5;
    node.scoreLabel.position = CGPointMake(nodeSize.width / 2, nodeSize.height * 0.3);
    if (fadeInOut) {
        SKAction *fadeOut = [SKAction fadeOutWithDuration:0.5];
        SKAction *fadeIn = [SKAction fadeInWithDuration:0.5];
        SKAction *foreverFadeInOut = [SKAction repeatActionForever:[SKAction sequence:@[fadeOut, fadeIn]]];
        [node.scoreLabel runAction:foreverFadeInOut];
    }
    
    [node addChild:roundCircle];
    [node addChild:innerRoundCircle];
    [node addChild:node.scoreLabel];
    
    return node;
}

-(void)updateScore:(int)score isFadeInOut:(BOOL)fadeInOut {
    if (score < _score || (_score < 0 && score >= 0)) {
        _scoreLabel.text = [NSString stringWithFormat:@"%d", score];
    }
    if (fadeInOut) {
        SKAction *fadeOut = [SKAction fadeOutWithDuration:0.5];
        SKAction *fadeIn = [SKAction fadeInWithDuration:0.5];
        SKAction *foreverFadeInOut = [SKAction repeatActionForever:[SKAction sequence:@[fadeOut, fadeIn]]];
        [_scoreLabel runAction:foreverFadeInOut];
    } else {
        [_scoreLabel removeAllActions];
        _scoreLabel.alpha = 1.0;
    }
}

@end
