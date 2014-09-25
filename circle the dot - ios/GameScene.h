//
//  GameScene.h
//  circle the dot - ios
//

//  Copyright (c) 2014年 Reeonce. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene

- (void)lose;
- (void)win: (int)steps;
- (void)removeResultLabel;
- (void)updateSteps: (int)steps;
- (void)doRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
- (void)rotateToLandscape;
- (void)rotateToPortrait;

@property UIInterfaceOrientation preferredInterfaceOrientationForPresentation;

@end
