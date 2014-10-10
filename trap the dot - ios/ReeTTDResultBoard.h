//
//  ReeTTDResultBoard.h
//  Trap The Dot !
//
//  Created by Reeonce Zeng on 9/27/14.
//  Copyright (c) 2014 Reeonce. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ReeTTDTypes.h"
#import "ReeTTDUserData.h"

@interface ReeTTDResultBoard : SKSpriteNode

- (void) viewDidLoad: (SKView  *)view;
- (void) showResult: (ReeTTDResult)result stepsUsed:(int)steps;
- (void) hiddenResult;
-(void)changeGameModeTo:(ReeTTDMode)mode;

@property (nonatomic) ReeTTDUserData *userData;

@end
