//
//  ReeTTDBoard-PlayGame.h
//  Trap The Dot
//
//  Created by Reeonce Zeng on 11/20/14.
//  Copyright (c) 2014 Reeonce. All rights reserved.
//

#ifndef Trap_The_Dot_ReeTTDBoard_PlayGame_h
#define Trap_The_Dot_ReeTTDBoard_PlayGame_h

#import "ReeTTDBoard.h"
#import "ReeTTDTypes.h"
#import "ReeTTDUserData.h"
#import "ReeQueue.h"

@interface ReeTTDBoard (PlayGame)

-(void)sortCircleNets;
-(void)gameWillEnd: (BOOL)isWin;

@end

#endif
