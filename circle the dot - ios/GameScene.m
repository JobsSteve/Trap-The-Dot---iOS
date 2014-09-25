//
//  GameScene.m
//  circle the dot - ios
//
//  Created by Reeonce on 14-9-18.
//  Copyright (c) 2014年 Reeonce. All rights reserved.
//

#import "GameScene.h"
#import "ReeCTDBoard.h"
#import "ReeCTDNode.h"


@implementation GameScene {
    ReeCTDBoard *board;
    SKLabelNode *myLabel;
    SKLabelNode *gameResultLabel;
    SKLabelNode *shareLabel;
    SKLabelNode *reviewLabel;
}

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    myLabel.text = @"Circle The Dot";
    myLabel.fontSize = 45;
    
    gameResultLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    gameResultLabel.text = [NSString stringWithFormat:@"%d Step", 0];
    gameResultLabel.fontSize = 40;
    
    
    board = [ReeCTDBoard spriteNodeWithColor:[UIColor colorWithWhite:0 alpha:0] size:CGSizeMake(420, 360)];
    [board renderGame];
    board.anchorPoint = CGPointMake(0, 0);

    shareLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    shareLabel.text = @"Share";
    shareLabel.fontSize = 40;
    
    reviewLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    reviewLabel.text = @"Review";
    reviewLabel.fontSize = 40;
    
    UIInterfaceOrientation orientation = [self preferredInterfaceOrientationForPresentation];
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        [self rotateToLandscape];
    } else {
        [self rotateToPortrait];
    }
    
    [self addChild:myLabel];
    [self addChild:gameResultLabel];
    [self addChild:board];
    [self addChild:shareLabel];
    [self addChild:reviewLabel];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint posToBoard = [touch locationInNode:board];
        if (posToBoard.x > 0 && posToBoard.x < CGRectGetWidth(board.frame) &&
            posToBoard.y > 0 && posToBoard.y < CGRectGetHeight(board.frame)) {
            [board clicked: posToBoard];
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

-(void)win: (int)steps {
    if (steps >= 2) {
        gameResultLabel.text = [NSString stringWithFormat:@"WIN: %d Steps", steps];
    } else {
        gameResultLabel.text = [NSString stringWithFormat:@"WIN: %d Step", steps];
    }
}

-(void)lose {
    gameResultLabel.text = @"LOSE";
}

-(void)removeResultLabel {
    [gameResultLabel removeFromParent];
}

-(void)updateSteps: (int)steps {
    if (steps >= 2) {
        gameResultLabel.text = [NSString stringWithFormat:@"%d Steps", steps];
    } else {
        gameResultLabel.text = [NSString stringWithFormat:@"%d Step", steps];
    }
}

- (void)doRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        [self rotateToLandscape];
    } else {
        [self rotateToPortrait];
    }
}

-(void)rotateToLandscape {
    board.position = CGPointMake(CGRectGetMaxX(self.frame) - 700,
                                 CGRectGetMinY(self.frame) + 80);
    
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMaxY(self.frame) - 100);
    myLabel.fontSize = 55;
    gameResultLabel.position = CGPointMake(CGRectGetMinX(self.frame) + 180,
                                           CGRectGetMinY(self.frame) + 480);
    shareLabel.position = CGPointMake(CGRectGetMinX(self.frame) + 180,
                                      CGRectGetMinY(self.frame) + 280);
    reviewLabel.position = CGPointMake(CGRectGetMinX(self.frame) + 180,
                                      CGRectGetMinY(self.frame) + 140);
    board.size = CGSizeMake(560, 480);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        board.size = CGSizeMake(600, 520);
        board.position = CGPointMake(CGRectGetMaxX(self.frame) - 640,
                                     CGRectGetMinY(self.frame) + 120);
        myLabel.position = CGPointMake(CGRectGetMinX(self.frame) + 180,
                                       CGRectGetMaxY(self.frame) - 160);
        myLabel.text = @"Circle The Dot";
        myLabel.fontSize = 40;
        gameResultLabel.position = CGPointMake(CGRectGetMinX(self.frame) + 180,
                                               CGRectGetMinY(self.frame) + 440);
    }
}

-(void)rotateToPortrait {
    board.position = CGPointMake(CGRectGetMidX(self.frame) - 210,
                                 CGRectGetMaxY(self.frame) - 620);
    
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMaxY(self.frame) - 100);
    gameResultLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                           CGRectGetMaxY(self.frame) - 180);
    shareLabel.position = CGPointMake(CGRectGetMidX(self.frame) - 120,
                                      CGRectGetMinY(self.frame) + 60);
    reviewLabel.position = CGPointMake(CGRectGetMidX(self.frame) + 120,
                                       CGRectGetMinY(self.frame) + 60);
    board.size = CGSizeMake(420, 360);
}

@end
