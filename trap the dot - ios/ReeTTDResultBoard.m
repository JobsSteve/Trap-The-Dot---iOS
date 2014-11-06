//
//  ReeTTDResultBoard.m
//  Trap The Dot !
//
//  Created by Reeonce Zeng on 9/27/14.
//  Copyright (c) 2014 Reeonce. All rights reserved.
//

#import "ReeTTDResultBoard.h"
#import "ReeTTDButton.h"
#import "GameScene.h"
#import "ReeTTDConfiguration.h"

@implementation ReeTTDResultBoard {
    NSString *winTitle;
    NSString *loseTitle;
    NSString *winDescription;
    NSString *loseDescription;
    
    SKLabelNode *resultLabel;
    SKLabelNode *descLabel;
    
    ReeTTDButton *nextButton;
    ReeTTDButton *againButton;
    ReeTTDButton *replayButton;
    ReeTTDButton *changeModeButton;
    ReeTTDButton *rateButton;
    
    SKView *skView;
}

- (void) viewDidLoad: (SKView  *)view {
    skView = view;
    self.userData = [ReeTTDUserData getInstance];
    
    winTitle = NSLocalizedString(@"WIN_TITLE", @"Congratulations");
    loseTitle = NSLocalizedString(@"LOSE_TITLE", @"Sorry, Sorry");
    winDescription = NSLocalizedString(@"WIN_DESCRIPTION", @"Oh! You only use %d steps");
    loseDescription = NSLocalizedString(@"LOSE_DESCRIPTION", @"The dot escaped. T_T");
    
    resultLabel = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
    resultLabel.fontSize = 40;
    resultLabel.fontColor = [SKColor colorWithWhite: 0.9 alpha:1.0];
    resultLabel.position = CGPointMake(CGRectGetMidX(self.frame), 580);
    
    descLabel = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Regular"];
    descLabel.fontSize = 28;
    descLabel.fontColor = [SKColor colorWithWhite:0.8 alpha:1.0];
    descLabel.position = CGPointMake(CGRectGetMidX(self.frame), 520);
    
    nextButton = [ReeTTDButton ButtonWithRect:CGRectMake(CGRectGetMidX(self.frame) - 100, 400, 200, 50) cornerRadius:8.0 Text:NSLocalizedString(@"NEXT_LEVEL", @"Next Level")];
    replayButton = [ReeTTDButton ButtonWithRect:CGRectMake(CGRectGetMidX(self.frame) - 100, 400, 200, 50) cornerRadius:8.0 Text:NSLocalizedString(@"REPLAY", @"Replay")];
    againButton = [ReeTTDButton ButtonWithRect:CGRectMake(CGRectGetMidX(self.frame) - 100, 300, 200, 50) cornerRadius:8.0 Text:NSLocalizedString(@"ONCE_MORE", @"Once Again")];
    changeModeButton = [ReeTTDButton ButtonWithRect:CGRectMake(CGRectGetMidX(self.frame) - 100, 200, 200, 50) cornerRadius:8.0 Text:NSLocalizedString(@"HOME", @"Home")];
    rateButton = [ReeTTDButton ButtonWithRect:CGRectMake(CGRectGetMidX(self.frame) - 100, 100, 200, 50) cornerRadius:8.0 Text:NSLocalizedString(@"RATE_ME", @"评分")];
    
    [self addChild:resultLabel];
    [self addChild:descLabel];
    [self addChild:changeModeButton];
    if (self.userData.gameMode == ReeTTDModeRandom) {
        //[self addChild:replayButton];
    } else {
        [self addChild:nextButton];
    }
    [self addChild:againButton];
    [self addChild:rateButton];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        NSArray *touchNodes = [self nodesAtPoint:[touch locationInNode:self]];
        SKNode *node = (SKNode *)touchNodes.firstObject;
        if (node.self == nextButton.self) {
            GameScene *gs = (GameScene *)[self parent];
            [self hiddenResult];
            [gs nextLevel];
        } else if (node.self == replayButton.self) {
            GameScene *gs = (GameScene *)[self parent];
            [self hiddenResult];
            [gs replayGame];
        } else if (node.self == againButton.self) {
            GameScene *gs = (GameScene *)[self parent];
            [self hiddenResult];
            [gs retryCurrentLevel];
        } else if (node.self == changeModeButton.self) {
            GameScene *gs = (GameScene *)[self parent];
            [self hiddenResult];
            [gs changeGameMode];
        } else if (node.self == rateButton.self) {
            NSString *appid = (NSString *)[ReeTTDConfiguration getValueWithKey:@"AppID"];
            NSString *rateURL = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", appid];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:rateURL]];
        }
    }
    
}

- (void) showResult: (ReeTTDResult)result stepsUsed:(int)steps{
    if (result == gameWin) {
        resultLabel.text = winTitle;
        descLabel.text = [NSString stringWithFormat:winDescription, steps];
    } else {
        resultLabel.text = loseTitle;
        descLabel.text = loseDescription;
    }
}

- (void) hiddenResult {
    [self removeFromParent];
}

-(void)changeGameModeTo:(ReeTTDMode)mode {
    if (replayButton) {
        //[replayButton removeFromParent];
    }
    if (nextButton) {
        [nextButton removeFromParent];
    }
    if (mode == ReeTTDModeEasy || mode == ReeTTDModeHard) {
        [self addChild:nextButton];
    } else {
        
        //[self addChild:replayButton];
    }
}

@end
