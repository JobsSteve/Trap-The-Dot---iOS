//
//  ReeTTDLevelsBoard.m
//  Trap The Dot
//
//  Created by Reeonce Zeng on 9/30/14.
//  Copyright (c) 2014 Reeonce. All rights reserved.
//

#import "ReeTTDLevelsBoard.h"
#import "ReeTTDLevelNode.h"

@implementation ReeTTDLevelsBoard {
    NSMutableArray *lineScoreNodes;
}

const int lineCount = 5;

-(void)viewDidLoaded:(NSArray *)levelScores {
    lineScoreNodes = [[NSMutableArray alloc] init];
    
    BOOL hadFadeInOutNode = NO;
    for (int i=0; i<lineCount; i++) {
        ReeTTDLevelNode *challengeModeButton;
        int score = [(NSNumber *)([levelScores objectAtIndex:i]) intValue];
        if (score < 0 && !hadFadeInOutNode) {
            hadFadeInOutNode = YES;
            challengeModeButton = [ReeTTDLevelNode levelNodeWithSize:CGSizeMake(60, 60) backgroudColor:[SKColor colorWithWhite:0.8 alpha:0.8] fontColor:[SKColor colorWithWhite:0.2 alpha:1.0] levelScore:score isFadeInOut:YES];
        } else {
            challengeModeButton = [ReeTTDLevelNode levelNodeWithSize:CGSizeMake(60, 60) backgroudColor:[SKColor colorWithWhite:0.8 alpha:0.8] fontColor:[SKColor colorWithWhite:0.2 alpha:1.0] levelScore:score isFadeInOut:NO];
        }
        challengeModeButton.position = CGPointMake(i * 80, 30);
        SKLabelNode *levelLable = [SKLabelNode labelNodeWithFontNamed:@""];
        levelLable.text = [NSString stringWithFormat:@"%d", 1 + i];
        levelLable.position = CGPointMake(30 + i * 80, 0);
        [self addChild:challengeModeButton];
        [self addChild:levelLable];
        [lineScoreNodes addObject:challengeModeButton];
    }
}

-(int)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        NSArray *touchNodes = [self nodesAtPoint:[touch locationInNode:self]];
        SKNode *node = (SKNode *)touchNodes.firstObject;
        SKNode *scoreNode;
        for (int i=0; i<lineCount; i++) {
            scoreNode = [lineScoreNodes objectAtIndex:i];
            if (scoreNode.self == node.self) {
                return i + 1;
            }
        }
    }
    return 0;
}

-(void) updateScores:(NSArray *)levelScores {
    ReeTTDLevelNode *scoreNode;
    int score;
    
    BOOL hadFadeInOutNode = NO;
    for (int i=0; i<lineCount; i++) {
        score = [[levelScores objectAtIndex:i]  intValue];
        scoreNode = [lineScoreNodes objectAtIndex:i];
        
        if (score < 0 && !hadFadeInOutNode) {
            [scoreNode updateScore:score isFadeInOut:YES];
            hadFadeInOutNode = YES;
        } else {
            [scoreNode updateScore: score isFadeInOut:NO];
        }
    }
}

@end
