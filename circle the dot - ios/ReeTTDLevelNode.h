//
//  ReeTTDLevelNode.h
//  Trap The Dot
//
//  Created by Reeonce Zeng on 9/30/14.
//  Copyright (c) 2014 Reeonce. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ReeTTDLevelNode : SKSpriteNode

+(instancetype)levelNodeWithSize:(CGSize)nodeSize backgroudColor:(SKColor *)backgroundColor fontColor:(SKColor *)fontColor levelScore:(int)score isFadeInOut:(BOOL)fadeInOut;

-(void)updateScore:(int)score isFadeInOut:(BOOL)fadeInOut;

@property (nonatomic) SKLabelNode *scoreLabel;
@property (nonatomic) int score;

@end
