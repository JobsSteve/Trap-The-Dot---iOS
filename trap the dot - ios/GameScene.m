//
//  GameScene.m
//  Trap The Dot - ios
//
//  Created by Reeonce on 14-9-18.
//  Copyright (c) 2014年 Reeonce. All rights reserved.
//

#import "GameScene.h"
#import "ReeTTDBoard.h"
#import "ReeTTDNode.h"
#import "ReeTTDButton.h"
#import "ReeTTDConfiguration.h"
#import "ReeSwitchIcon.h"

@implementation GameScene {
    SKView *skView;
	
}

@synthesize gameBoard = gameBoard;
@synthesize gameTitleLabel = gameTitleLabel;
@synthesize gameResultLabel = gameResultLabel;
@synthesize resultBoard = resultBoard;
@synthesize navPage = navPage;
@synthesize replayButton = replayButton;
@synthesize nextPlayButton = nextPlayButton;

-(void)didMoveToView:(SKView *)view {
	self.userData = [ReeTTDUserData getInstance];
	
    skView = view;
	if (self.userData.colorful) {
		self.backgroundColor = [SKColor colorWithWhite:0.6 alpha:1];
	} else {
		self.backgroundColor = [SKColor colorWithWhite:0.8 alpha:1];
	}
	[self.userData addObserver:self forKeyPath:@"colorful" options:NSKeyValueObservingOptionNew context:nil];
	
    /* Setup your scene here */
    [self initNodes: view];
    
    UIInterfaceOrientation orientation = [self preferredInterfaceOrientationForPresentation];
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        [self rotateToLandscape];
    } else {
        [self rotateToPortrait];
    }
}

-(void)initNodes:(SKView *)view {
    gameTitleLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    gameTitleLabel.text = NSLocalizedString(@"GAME_TITLE" , @"Trap The Dot !");
    gameTitleLabel.zPosition = 100;
    gameTitleLabel.fontSize = 45;
    
    gameResultLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    gameResultLabel.text = [NSString stringWithFormat:NSLocalizedString(@"0_OR_1_STEP" , @"contain a %d "), 0];
    gameResultLabel.fontSize = 40;
	
	replayButton = [SKSpriteNode spriteNodeWithImageNamed:@"replay"];;

	nextPlayButton = [SKSpriteNode spriteNodeWithImageNamed:@"nextPlay"];
    
    /*init the game playing board*/
    gameBoard = [ReeTTDBoard spriteNodeWithColor:[UIColor colorWithWhite:0 alpha:0] size:CGSizeMake(420, 360)];
	[gameBoard renderGameWithMode:self.userData.gameMode Level:[self.userData getMaxLevel:self.userData.gameMode]];
    gameBoard.anchorPoint = CGPointMake(0, 0);
    gameBoard.userInteractionEnabled = YES;
	[gameBoard addObserver:self forKeyPath:@"steps" options:NSKeyValueObservingOptionNew context:nil];
	[gameBoard addObserver:self forKeyPath:@"gameState" options:NSKeyValueObservingOptionNew context:nil];
	[self.userData addObserver:gameBoard forKeyPath:@"colorful" options:NSKeyValueObservingOptionNew context:nil];
	
    /*init the board when ending one game*/
    resultBoard = [ReeTTDResultBoard spriteNodeWithColor:[SKColor colorWithWhite:0.5 alpha:0.95] size:CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    resultBoard.anchorPoint = CGPointMake(0, 0);
    resultBoard.zPosition = 10;
    [resultBoard viewDidLoad:view];
    resultBoard.userInteractionEnabled = YES;
	
	navPage = [[ReeTTDNavPage alloc] initWithColor:[SKColor colorWithWhite:0.8 alpha:1.0] size:self.frame.size];
	if (self.userData.gameMode == ReeTTDModeunknow) {
		[self addChild:navPage];
	}
	[navPage viewDidLoadedWithEasyScores:self.userData.easyLevelScores hardScores:self.userData.hardLevelScores randomScore:self.userData.randomModeScore];
	navPage.userInteractionEnabled = YES;
	[navPage addObserver:self forKeyPath:@"gameMode" options:NSKeyValueObservingOptionNew context:nil];
	
	SKTexture *texture1 = [SKTexture textureWithImageNamed:@"soundOn"];
	SKTexture *texture2 = [SKTexture textureWithImageNamed:@"soundOff"];
	ReeSwitchIcon *soundIcon = [ReeSwitchIcon switchIconWithSize:CGSizeMake(40, 40) onTexture:texture1 offTexture:texture2 defaultOn:self.userData.soundOn];
	gameBoard.soundOn = self.userData.soundOn;
	soundIcon.position = CGPointMake(CGRectGetMinX(self.frame) + 230, CGRectGetMaxY(self.frame) - 45);
	soundIcon.anchorPoint = CGPointZero;
	soundIcon.name = @"soundIcon";
	soundIcon.zPosition = 9;
	[self addChild:soundIcon];
	[soundIcon addObserver:gameBoard forKeyPath:@"stateOn" options:NSKeyValueObservingOptionNew context:nil];
	
	SKTexture *texture3 = [SKTexture textureWithImageNamed:@"colorful"];
	SKTexture *texture4 = [SKTexture textureWithImageNamed:@"colorless"];
	ReeSwitchIcon *colorIcon = [ReeSwitchIcon switchIconWithSize:CGSizeMake(35, 35) onTexture:texture3 offTexture:texture4 defaultOn:self.userData.colorful];
	colorIcon.position = CGPointMake(CGRectGetMaxX(self.frame) - 270, CGRectGetMaxY(self.frame) - 45);
	colorIcon.anchorPoint = CGPointZero;
	colorIcon.name = @"colorIcon";
	colorIcon.zPosition = 9;
	[self addChild:colorIcon];
	[colorIcon addObserver:self.userData forKeyPath:@"stateOn" options:NSKeyValueObservingOptionNew context:nil];
	
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		soundIcon.position = CGPointMake(CGRectGetMinX(self.frame) + 300, CGRectGetMaxY(self.frame) - 45);
		colorIcon.position = CGPointMake(CGRectGetMaxX(self.frame) - 340, CGRectGetMaxY(self.frame) - 45);
	}
	
	[self addChild:gameTitleLabel];
	[self addChild:gameResultLabel];
	[self addChild:gameBoard];
	[self addChild:replayButton];
	[self addChild:nextPlayButton];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

-(void)showResult: (ReeTTDResult)result stepsUsed:(int)steps {
    [resultBoard showResult:result stepsUsed:steps];
	[resultBoard hiddenResult];
    [self addChild:resultBoard];
}

-(void)goToMode:(ReeTTDMode)mode Level: (int)level {
	[gameBoard renderGameWithMode:mode Level:level];
	[self updateSteps:0];
}

-(void)nextLevel {
	if ([gameBoard nextLevel]) {
		[self updateSteps:0];
	} else {
		[self changeGameMode];
	}
}

-(void)retryCurrentLevel {
    [gameBoard retryCurrentLevel];
    [self updateSteps:0];
}

-(void)replayGame {
	[gameBoard replayCurrentLevel];
	[self updateSteps:0];
}

-(void)removeResultLabel {
    [gameResultLabel removeFromParent];
}

-(void)updateSteps: (int)steps {
    if (steps >= 2) {
        gameResultLabel.text = [NSString stringWithFormat: NSLocalizedString(@"N_STEPS", @"contain a %d "), steps];
    } else {
        gameResultLabel.text = [NSString stringWithFormat:NSLocalizedString(@"0_OR_1_STEP", @"contain a %d "), steps];
    }
}

- (void)doRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        [self rotateToLandscape];
    } else {
        [self rotateToPortrait];
    }
}

/*position and size changes when rotate to landscape mode*/
-(void)rotateToLandscape {
    gameBoard.position = CGPointMake(CGRectGetMaxX(self.frame) - 700,
									 CGRectGetMinY(self.frame) + 80);
	gameBoard.size = CGSizeMake(600, 520);
	
    gameTitleLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMaxY(self.frame) - 100);
    gameTitleLabel.fontSize = 55;
    gameResultLabel.position = CGPointMake(CGRectGetMinX(self.frame) + 180,
										   CGRectGetMinY(self.frame) + 480);
	replayButton.size = CGSizeMake(60, 60);
	replayButton.position = CGPointMake(CGRectGetMinX(self.frame) + 180,
										CGRectGetMinY(self.frame) + 280);
	nextPlayButton.size = CGSizeMake(60, 60);
	nextPlayButton.position = CGPointMake(CGRectGetMinX(self.frame) + 180,
										  CGRectGetMinY(self.frame) + 140);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        gameBoard.size = CGSizeMake(600, 520);
        gameBoard.position = CGPointMake(CGRectGetMaxX(self.frame) - 640,
                                     CGRectGetMinY(self.frame) + 120);
        gameTitleLabel.position = CGPointMake(CGRectGetMinX(self.frame) + 180,
                                       CGRectGetMaxY(self.frame) - 60);
        gameResultLabel.position = CGPointMake(CGRectGetMinX(self.frame) + 180,
                                               CGRectGetMinY(self.frame) + 440);
    }
}

/*position and size changes when rotate to portrait mode*/
-(void)rotateToPortrait {
    gameBoard.position = CGPointMake(CGRectGetMidX(self.frame) - 210,
                                 CGRectGetMaxY(self.frame) - 620);
	gameBoard.size = CGSizeMake(420, 360);
	
    gameTitleLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMaxY(self.frame) - 100);
    gameResultLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                           CGRectGetMaxY(self.frame) - 180);
	
	replayButton.size = CGSizeMake(46, 46);
	replayButton.position = CGPointMake(CGRectGetMidX(self.frame) - 120,
										CGRectGetMinY(self.frame) + 80);
	
	nextPlayButton.size = CGSizeMake(46, 46);
	nextPlayButton.position = CGPointMake(CGRectGetMidX(self.frame) + 120,
										CGRectGetMinY(self.frame) + 80);
}

-(void)changeGameMode {
	[navPage updateScoresWithEasyScores:self.userData.easyLevelScores hardScores:self.userData.hardLevelScores randomScore:self.userData.randomModeScore];
	[self addChild:navPage];
}

/*nodes update when switching to random mode xx */
-(void)switchToRandomMode{
	self.userData.gameMode = ReeTTDModeRandom;
	[gameBoard renderGameWithMode:ReeTTDModeRandom Level:0];
	[resultBoard changeGameModeTo:ReeTTDModeRandom];
	[self updateSteps:0];
}

/*nodes update when switching to challenge mode xx */
-(void)switchToChallengeModeWithMode:(ReeTTDMode)mode Level: (int)level {
	self.userData.gameMode = mode;
	[gameBoard renderGameWithMode:mode Level:level];
	[resultBoard changeGameModeTo:mode];
	[self updateSteps:0];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	for (UITouch *touch in touches) {
		SKNode *node = (SKNode *)[self nodeAtPoint:[touch locationInNode:self]];
		if (node.self == replayButton.self) {
			[self replayGame];
		} else if (node.self == nextPlayButton.self) {
			[self retryCurrentLevel];
		}
	}
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"steps"]) {
		int steps = [[change objectForKey:NSKeyValueChangeNewKey] intValue];
		[self updateSteps:steps];
	} else if ([keyPath isEqualToString:@"gameState"]) {
		int state = [[change valueForKey:NSKeyValueChangeNewKey] intValue];
		if (state == ReeTTDGameStateWin) {
			[self showResult:gameWin stepsUsed:self.gameBoard.steps];
		} else if (state == ReeTTDGameStateLose) {
			[self showResult:gameLose stepsUsed:self.gameBoard.steps];
		}
	} else if ([keyPath isEqualToString:@"gameMode"]) {
		int mode = [[change valueForKey:NSKeyValueChangeNewKey] intValue];
		if (mode == ReeTTDModeRandom) {
			[self switchToRandomMode];
		} else {
			[self switchToChallengeModeWithMode:mode Level:navPage.level];
		}
	} else if ([keyPath isEqualToString:@"colorful"]) {
		BOOL colorful = [[change valueForKey:NSKeyValueChangeNewKey] boolValue];
		if (colorful) {
			self.backgroundColor = [SKColor colorWithWhite:0.6 alpha:1];
		} else {
			self.backgroundColor = [SKColor colorWithWhite:0.8 alpha:1];
		}
	}
}

@end
