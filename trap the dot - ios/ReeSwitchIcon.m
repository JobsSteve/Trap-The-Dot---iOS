//
//  ReeSoundIcon.m
//  Trap The Dot
//
//  Created by Reeonce Zeng on 10/7/14.
//  Copyright (c) 2014 Reeonce. All rights reserved.
//

#import "ReeSwitchIcon.h"

@implementation ReeSwitchIcon

@synthesize stateOn = _stateOn;

-(id)init {
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

+(instancetype)switchIconWithSize:(CGSize)buttonSize onTexture:(SKTexture *)onTexture offTexture:(SKTexture *)offTexture defaultOn:(BOOL)on {
    ReeSwitchIcon *button = [[ReeSwitchIcon alloc] init];
    button.onTexture = onTexture;
    button.offTexture = offTexture;
    button.size = buttonSize;
    
    [button switchToOn:on];
    
    return button;
}

-(void)switchToOn:(BOOL)toOn {
    if (toOn) {
        self.texture = _onTexture;
    } else {
        self.texture = _offTexture;
    }
    self.stateOn = toOn;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self switchToOn:(!_stateOn)];
}

@end
