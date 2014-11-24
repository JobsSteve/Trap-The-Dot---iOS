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
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"

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
    ReeTTDButton *shareFBButton;
    
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
    resultLabel.fontSize = 36;
    resultLabel.fontColor = [SKColor colorWithWhite: 0.9 alpha:1.0];
    resultLabel.position = CGPointMake(CGRectGetMidX(self.frame), 580);
    
    descLabel = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Regular"];
    descLabel.fontSize = 28;
    descLabel.fontColor = [SKColor colorWithWhite:0.8 alpha:1.0];
    descLabel.position = CGPointMake(CGRectGetMidX(self.frame), 520);
    
    
    button1 = CGRectMake(CGRectGetMidX(self.frame) - 100, 400, 200, 50);
    button2 = CGRectMake(CGRectGetMidX(self.frame) - 100, 300, 200, 50);
    button3 = CGRectMake(CGRectGetMidX(self.frame) - 100, 200, 200, 50);
    button4 = CGRectMake(CGRectGetMidX(self.frame) - 100, 100, 200, 50);
    
    nextButton = [ReeTTDButton ButtonWithRect: button1 cornerRadius:8.0 Text:NSLocalizedString(@"NEXT_LEVEL", @"Next Level")];
    againButton = [ReeTTDButton ButtonWithRect:button2 cornerRadius:8.0 Text:NSLocalizedString(@"ONCE_MORE", @"Once Again")];
    changeModeButton = [ReeTTDButton ButtonWithRect:button3 cornerRadius:8.0 Text:NSLocalizedString(@"HOME", @"Home")];
    rateButton = [ReeTTDButton ButtonWithRect:button4 cornerRadius:8.0 Text:NSLocalizedString(@"RATE_ME", @"评分")];
    
    shareFBButton = [ReeTTDButton ButtonWithRect:button4 cornerRadius:8.0 Text:NSLocalizedString(@"Share", @"分享")];
    
    
    [self addChild:resultLabel];
    [self addChild:descLabel];
    [self addChild:changeModeButton];
    if (self.userData.gameMode == ReeTTDModeRandom) {
        againButton.position = button1.origin;
        changeModeButton.position = button2.origin;
        rateButton.position = button3.origin;
        
        [self addChild:shareFBButton];
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
        } else if (node.self == shareFBButton.self) {
            [self shareWithFB];
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


CGRect button1;
CGRect button2;
CGRect button3;
CGRect button4;

-(void)changeGameModeTo:(ReeTTDMode)mode {
    if (nextButton) {
        [nextButton removeFromParent];
    }
    if (mode == ReeTTDModeEasy || mode == ReeTTDModeHard) {
        [self addChild:nextButton];
        againButton.position = button2.origin;
        changeModeButton.position = button3.origin;
        rateButton.position = button4.origin;
    } else {
        againButton.position = button1.origin;
        changeModeButton.position = button2.origin;
        rateButton.position = button3.origin;
    }
}


- (void)shareWithFB {
    
    __block ReeTTDResultBoard *rb = self;
    
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [rb shareFBContent];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             NSLog(@"openActiveSessionWithReadPermissions success");
             // Retrieve the app delegate
             AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
             [rb shareFBContent];
         }];
    }
}

- (void)shareFBContent {
    GameScene *gs = (GameScene *)self.scene;
    
    [FBRequestConnection startForUploadStagingResourceWithImage: gs.playImage completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if(!error) {
            // Log the uri of the staged image
            NSLog(@"Successfuly staged image with staged URI: %@", [result objectForKey:@"uri"]);
            
            // Further code to post the OG story goes here
            NSString *imageUrl = (NSString *)[result objectForKey:@"uri"];
            
            // instantiate a Facebook Open Graph object
            NSMutableDictionary<FBOpenGraphObject> *ogObject = [FBGraphObject openGraphObjectForPost];
            
            // specify that this Open Graph object will be posted to Facebook
            ogObject.provisionedForPost = YES;
            
            // for og:title
            ogObject[@"title"] = @"Roasted pumpkin seeds";
            
            // for og:type, this corresponds to the Namespace you've set for your app and the object type name
            ogObject[@"type"] = @"reeonce:step";
            
            // for og:description
            ogObject[@"description"] = @"Crunchy pumpkin seeds roasted in butter and lightly salted.";
            
            // for og:url, we cover how this is used in the "Deep Linking" section below
            ogObject[@"url"] = @"http://example.com/roasted_pumpkin_seeds";
            
            // for og:image we assign the image that we just staged, using the uri we got as a response
            // the image has to be packed in a dictionary like this:
            ogObject[@"image"] = @[@{@"url": imageUrl, @"user_generated" : @"false" }];
            [FBRequestConnection startForPostOpenGraphObject:ogObject completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if(!error) {
                    // get the object ID for the Open Graph object that is now stored in the Object API
                    NSString *objectId = [result objectForKey:@"id"];
                    
                    id<FBOpenGraphAction> action = (id<FBOpenGraphAction>)[FBGraphObject graphObject];
                    [action setObject:objectId forKey:@"step"];
                    
                    // create action referencing user owned object
                    [FBRequestConnection startForPostWithGraphPath:@"/me/reeonce:take" graphObject:action completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                        if(!error) {
                            FBOpenGraphActionParams *params = [[FBOpenGraphActionParams alloc] init];
                            params.action = action;
                            params.actionType = @"reeonce:take";
                            
                            // If the Facebook app is installed and we can present the share dialog
                            if([FBDialogs canPresentShareDialogWithOpenGraphActionParams:params]) {
                                // Show the share dialog
                                [FBDialogs presentShareDialogWithOpenGraphAction:action
                                                                      actionType:@"reeonce:take"
                                                             previewPropertyName:@"step"
                                                                         handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                                             if(error) {
                                                                                 // There was an error
                                                                                 NSLog([NSString stringWithFormat:@"Error publishing story: %@", error.description]);
                                                                             } else {
                                                                                 // Success
                                                                                 NSLog(@"result %@", results);
                                                                             }
                                                                         }];
                                
                                // If the Facebook app is NOT installed and we can't present the share dialog
                            } else {
                                // FALLBACK GOES HERE
                            }
                        } else {
                            // An error occurred
                            NSLog(@"Encountered an error posting to Open Graph: %@", error);
                        }
                    }];
                    
                } else {
                    // An error occurred
                    NSLog(@"Error posting the Open Graph object to the Object API: %@", error);
                }
            }];
        } else {
            // An error occurred
            NSLog(@"Error staging an image: %@", error);
        }
    }];
}


@end
