//
//  ReeTTDButton.m
//  Trap The Dot !
//
//  Created by Reeonce Zeng on 9/27/14.
//  Copyright (c) 2014 Reeonce. All rights reserved.
//

#import "ReeTTDButton.h"

@implementation ReeTTDButton {
    NSString *content;
}

+ (instancetype)ButtonWithRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius Text:(NSString *)text {
    ReeTTDButton *button = [[ReeTTDButton alloc] init];
    button.size = rect.size;
    button.position = rect.origin;
    button.anchorPoint = CGPointZero;
    SKShapeNode *background = [[SKShapeNode alloc] init];
    background.path = CGPathCreateWithRoundedRect(CGRectMake(0, 0, rect.size.width, rect.size.height), 8.0, 8.0, nil);
    background.lineWidth = 0;
    background.fillColor = [SKColor colorWithWhite:0.2 alpha:0.95];
    [button addChild:background];
    
    SKLabelNode *labelNode = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Regular"];
    labelNode.text = text;
    labelNode.color = [SKColor colorWithWhite:1 alpha:1];
    labelNode.fontSize = rect.size.height * 0.6;
    labelNode.position = CGPointMake(rect.size.width / 2, rect.size.height * 0.3);
    [button addChild:labelNode];

    return button;
}

@end
