//
//  ReeTTDTypes.h
//  Trap The Dot !
//
//  Created by Reeonce Zeng on 9/29/14.
//  Copyright (c) 2014 Reeonce. All rights reserved.
//

#ifndef Circle_The_Dot_ReeTTDTypes_h
#define Circle_The_Dot_ReeTTDTypes_h


typedef enum {
    ReeTTDModeRandom,
    ReeTTDModeEasy,
    ReeTTDModeHard,
    ReeTTDModeunknow
} ReeTTDMode;


typedef enum {
    ReeTTDDirectionLeftUp = 0, ReeTTDDirectionLeft, ReeTTDDirectionLeftDown, ReeTTDDirectionRightUp, ReeTTDDirectionRight, ReeTTDDirectionRightDown
} ReeTTDDirection;


typedef enum NodeType {
    normalNode,
    netNode,
    dotNode
} ReeTTDNodeType;


typedef struct {
    int x;
    int y;
} ReeTTDDotPosition;


typedef enum {
    gameWin,
    gameLose
} ReeTTDResult;

typedef enum {
    ReeTTDGameStatePlaying,
    ReeTTDGameStateWin,
    ReeTTDGameStateLose
} ReeTTDGameState;

#endif
