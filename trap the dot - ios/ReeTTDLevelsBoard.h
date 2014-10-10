//
//  ReeTTDLevelsBoard.h
//  Trap The Dot
//
//  Created by Reeonce Zeng on 9/30/14.
//  Copyright (c) 2014 Reeonce. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ReeTTDLevelsBoard : SKSpriteNode

-(void)viewDidLoaded:(NSArray *)levelScores;

-(int)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

-(void) updateScores:(NSArray *)levelScores;

@end
