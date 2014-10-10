//
//  ReeTTDUserData.m
//  Trap The Dot
//
//  Created by Reeonce Zeng on 10/8/14.
//  Copyright (c) 2014 Reeonce. All rights reserved.
//

#import "ReeTTDUserData.h"
#import "ReeTTDConfiguration.h"

@implementation ReeTTDUserData

/* This is a singleton instance */
static ReeTTDUserData *userData;

+(instancetype)getInstance {
    if (!userData) {
        userData = [[ReeTTDUserData alloc] init];
        [userData readUserDataWithEasyLevelRange:[ReeTTDConfiguration getEasyLevelRange] hardLevelRange:[ReeTTDConfiguration getHardLevelRange]];
    }
    
    return userData;
}

-(void)readUserDataWithEasyLevelRange:(NSRange)easyLevelRange hardLevelRange:(NSRange)hardLevelRange {
    NSUserDefaults *userDefaults =[NSUserDefaults standardUserDefaults];
    
    /*get saved challenger mode scores*/
    _allLevelScores = [userDefaults arrayForKey:@"allLevelScores"];
    if (!_allLevelScores) {
        NSNumber *originScore[TOTALLEVELS+1];
        for (int i=0; i<=TOTALLEVELS; i++) {
            originScore[i] = [NSNumber numberWithInt:-1];
        }
        _allLevelScores = [NSArray arrayWithObjects:originScore count:TOTALLEVELS+1];
        [userDefaults setObject:_allLevelScores forKey:@"allLevelScores"];
    }
    
    _easyLevelScores = [_allLevelScores subarrayWithRange:easyLevelRange];
    _hardLevelScores = [_allLevelScores subarrayWithRange:hardLevelRange];
    
    /*get last played mode*/
    NSString *lastPlayedMode = [userDefaults objectForKey:@"lastPlayedMode"];
    if (!lastPlayedMode) {
        _gameMode = ReeTTDModeunknow;
    } else if ([lastPlayedMode isEqualToString:@"ReeTTDModeRandom"]) {
        _gameMode = ReeTTDModeRandom;
    } else if ([lastPlayedMode isEqualToString:@"ReeTTDModeEasy"]) {
        _gameMode = ReeTTDModeEasy;
    } else if ([lastPlayedMode isEqualToString:@"ReeTTDModeHard"]) {
        _gameMode = ReeTTDModeHard;
    }
    
    
    /*get saved random mode score*/
    NSNumber *randomScore = [userDefaults objectForKey:@"randomModeScore"];
    if (!randomScore) {
        _randomModeScore = -1;
    } else {
        _randomModeScore = [randomScore intValue];
    }
    
    NSNumber *soundOnNumber = [userDefaults objectForKey:@"soundOn"];
    if (soundOnNumber && ![soundOnNumber boolValue]) {
        _soundOn = NO;
    } else {
        _soundOn = YES;
    }
    
    NSNumber *colorfulNumber = [userDefaults objectForKey:@"colorful"];
    if (colorfulNumber && ![colorfulNumber boolValue]) {
        _colorful = NO;
    } else {
        _colorful = YES;
    }
}


-(void)setSoundOn:(BOOL)on {
    _soundOn = on;
    
    NSUserDefaults *userDefaults =[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithBool:on] forKey:@"soundOn"];
}



-(void)setAllLevelScores:(NSArray *)scores {
    _allLevelScores = scores;
    NSUserDefaults *userDefaults =[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_allLevelScores forKey:@"allLevelScores"];
}


/*  */
-(void)setEasyLevelScores:(NSArray *)scores {
    _easyLevelScores = scores;
    
    NSArray *newScores = [NSArray arrayWithObject:[NSNumber numberWithInt:-1]];
    self.allLevelScores = [[newScores arrayByAddingObjectsFromArray:scores] arrayByAddingObjectsFromArray:_hardLevelScores];
}


/*  */
-(void)setHardLevelScores:(NSArray *)scores {
    _hardLevelScores = scores;
    
    NSArray *newScores = [NSArray arrayWithObject:[NSNumber numberWithInt:-1]];
    self.allLevelScores = [[newScores arrayByAddingObjectsFromArray:_easyLevelScores] arrayByAddingObjectsFromArray:scores];
}

-(NSUInteger)getMaxLevel:(ReeTTDMode)mode {
    if (mode == ReeTTDModeEasy) {
        for (int i=0; i<_easyLevelScores.count; i++) {
            if ([[_easyLevelScores objectAtIndex:i] intValue] < 0) {
                return (i + 1);
            }
        }
        return _easyLevelScores.count;
    } else if (mode == ReeTTDModeHard) {
        for (int i=0; i<_hardLevelScores.count; i++) {
            if ([[_hardLevelScores objectAtIndex:i] intValue] < 0) {
                return (i + 1);
            }
        }
        return _hardLevelScores.count;
    }
    return 0;
}


/*  */
-(void)setRandomModeScore:(int)score {
    _randomModeScore = score;
    
    NSUserDefaults *userDefaults =[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithInt:_randomModeScore] forKey:@"randomModeScore"];
}


/*  */
-(void)setGameMode:(ReeTTDMode)mode {
    _gameMode = mode;
    
    NSString *lastPlayMode;
    if (_gameMode == ReeTTDModeEasy) {
        lastPlayMode = @"ReeTTDModeEasy";
    } else if (_gameMode == ReeTTDModeHard) {
        lastPlayMode = @"ReeTTDModeHard";
    } else {
        lastPlayMode =  @"ReeTTDModeRandom";
    }
    NSUserDefaults *userDefaults =[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:lastPlayMode forKey:@"lastPlayedMode"];
}

-(void)setColorfulAgent:(BOOL)colorful {
    self.colorful = colorful;
    
    NSUserDefaults *userDefaults =[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithBool:colorful] forKey:@"colorful"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"stateOn"]) {
        BOOL colorful = [[change valueForKey:NSKeyValueChangeNewKey] boolValue];
        [self setColorfulAgent:colorful];
    }
}

@end
