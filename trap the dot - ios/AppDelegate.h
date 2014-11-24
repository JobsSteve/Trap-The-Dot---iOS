//
//  AppDelegate.h
//  Trap The Dot - ios
//
//  Created by Reeonce on 14-9-18.
//  Copyright (c) 2014年 Reeonce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;

@end

