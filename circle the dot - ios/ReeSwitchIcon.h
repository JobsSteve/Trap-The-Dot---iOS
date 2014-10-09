//
//  ReeSwitchIcon.m
//  Trap The Dot
//
//  Created by Reeonce Zeng on 10/7/14.
//  Copyright (c) 2014 Reeonce. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ReeSwitchIcon : SKSpriteNode

+(instancetype)switchIconWithSize:(CGSize)buttonSize onTexture:(SKTexture *)onTexture offTexture:(SKTexture *)offTexture defaultOn:(BOOL)on;

-(void)switchToOn:(BOOL)toOn;

@property BOOL stateOn;

@property (nonatomic) SKTexture *onTexture;
@property (nonatomic) SKTexture *offTexture;

@end
