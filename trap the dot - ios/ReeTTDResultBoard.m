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
#import "GameViewController.h"
#import "FBShareButton.h"

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
    FBShareButton *shareFBButton;
    
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
    
    shareFBButton = [FBShareButton fbShareButtonWithRect: button4 cornerRadius:8.0 Text:NSLocalizedString(@"SHARE", @"The text of 'Share'")];
    
    
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
        self.resultIsWin = YES;
        self.steps = steps;
    } else {
        resultLabel.text = loseTitle;
        descLabel.text = loseDescription;
        self.resultIsWin = NO;
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
        [shareFBButton removeFromParent];
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
        [self addChild:shareFBButton];
    }
}


- (void)shareWithFB {
    
    __block ReeTTDResultBoard *rb = self;
    
    if (FBSession.activeSession.state == FBSessionStateOpen) {

        [rb shareFBContent];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        GameViewController *controller = (GameViewController* )self.scene.view.window.rootViewController;
        
        [controller loginToFB];
    }
}

- (void)shareFBContent {
    GameScene *gs = (GameScene *)self.scene;
    __block GameViewController *controller = (GameViewController* )self.scene.view.window.rootViewController;
    controller.loadingIcon.hidden = NO;
    [controller.loadingIcon startAnimating];
    controller.gameView.hidden = YES;
    
    __block ReeTTDResultBoard *rb = self;
    
    __block NSString *alertTitle, *alertMessage;
    /* *
     * share an image to FB
    FBPhotoParams *params = [[FBPhotoParams alloc] init];
    
    // Note that params.photos can be an array of images.  In this example
    // we only use a single image, wrapped in an array.
    params.photos = @[gs.playImage];
    
    [FBDialogs presentShareDialogWithPhotoParams:params
                                     clientState:nil
                                         handler:^(FBAppCall *call,
                                                   NSDictionary *results,
                                                   NSError *error) {
                                             if (error) {
                                                 NSLog(@"Error: %@",
                                                       error.description);
                                             } else {
                                                 NSLog(@"Success!");
                                             }
                                             
                                             controller.gameView.hidden = NO;
                                             [controller.loadingIcon stopAnimating];
                                             controller.loadingIcon.hidden = YES;
                                         }];
    */
    [FBRequestConnection startForUploadStagingResourceWithImage: gs.playImage completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if(!error) {
            // Further code to post the OG story goes here
            NSString *imageUrl = (NSString *)[result objectForKey:@"uri"];
            
            // instantiate a Facebook Open Graph object
            NSMutableDictionary<FBOpenGraphObject> *ogObject = [FBGraphObject openGraphObjectForPost];
            
            // specify that this Open Graph object will be posted to Facebook
            ogObject.provisionedForPost = YES;
            
            // for og:title
            ogObject[@"title"] = @"Trap the Dot !";
            
            // for og:type, this corresponds to the Namespace you've set for your app and the object type name
            ogObject[@"type"] = @"reeonce:dot";
            
            if (rb.resultIsWin) {
                if (rb.steps > 1) {
                    ogObject[@"description"] = [NSString stringWithFormat: @"I have trapped the dot in %d steps, can you take less?", rb.steps];
                } else {
                    ogObject[@"description"] = [NSString stringWithFormat: @"I have trapped the dot in %d step, can you take less?", rb.steps];
                }
            } else {
                ogObject[@"description"] = [NSString stringWithFormat: @"The dot escaped. Can you help me? T_T "];
            }
            // for og:description
            
            // for og:url, we cover how this is used in the "Deep Linking" section below
            ogObject[@"url"] = (NSString *)[ReeTTDConfiguration getValueWithKey:@"AppStoreURL"];
            
            // for og:image we assign the image that we just staged, using the uri we got as a response
            // the image has to be packed in a dictionary like this:
            ogObject[@"image"] = @[@{@"url": imageUrl, @"user_generated" : @"false" }];
            [FBRequestConnection startForPostOpenGraphObject:ogObject completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if(!error) {
                    // get the object ID for the Open Graph object that is now stored in the Object API
                    NSString *objectId = [result objectForKey:@"id"];
                    
                    id<FBOpenGraphAction> action = (id<FBOpenGraphAction>)[FBGraphObject graphObject];
                    [action setObject:objectId forKey:@"dot"];
                    
                    // create action referencing user owned object
                    [FBRequestConnection startForPostWithGraphPath:@"/me/reeonce:trap" graphObject:action completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                        if(!error) {
                            FBOpenGraphActionParams *params = [[FBOpenGraphActionParams alloc] init];
                            params.action = action;
                            params.actionType = @"reeonce:trap";
                            
                            // If the Facebook app is installed and we can present the share dialog
                            if([FBDialogs canPresentShareDialogWithOpenGraphActionParams:params]) {
                                // Show the share dialog
                                [FBDialogs presentShareDialogWithOpenGraphAction:action
                                                                      actionType:@"reeonce:trap"
                                                             previewPropertyName:@"dot"
                                                                         handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                                             
                                                                             controller.gameView.hidden = NO;
                                                                             [controller.loadingIcon stopAnimating];
                                                                             controller.loadingIcon.hidden = YES;
                                                                             if(error) {
                                                                                 alertTitle = @"Share To Facebook Error";
                                                                                 alertMessage = @"Error occored when publishing to Facebook.";
                                                                                 [rb showShareErrorWithTitle:alertTitle Message:alertMessage];
                                                                                 //NSLog([NSString stringWithFormat:@"Error publishing story: %@", error.description]);
                                                                                 
                                                                             } else {
                                                                                 // Success
                                                                                 //NSLog(@"result %@", results);
                                                                             }
                                                                         }];
                                
                                // If the Facebook app is NOT installed and we can't present the share dialog
                            } else {
                                alertTitle = @"Share To Facebook Error";
                                alertMessage = @"Please make sure you have Facebook app installed.";
                                [rb showShareErrorWithTitle:alertTitle Message:alertMessage];
                            }
                        } else {
                            // An error occurred
                            //NSLog(@"Encountered an error posting to Open Graph: %@", error);
                            
                            alertTitle = @"Share To Facebook Error";
                            alertMessage = @"Error occored when posting to Facebook.";
                            [rb showShareErrorWithTitle:alertTitle Message:alertMessage];
                        }
                    }];
                    
                } else {
                    // An error occurred
                    //NSLog(@"Error posting the Open Graph object to the Object API: %@", error);
                    
                    
                    alertTitle = @"Share To Facebook Error";
                    alertMessage = @"Error occored when posting to Facebook.";
                    [rb showShareErrorWithTitle:alertTitle Message:alertMessage];
                }
            }];
        } else {
            // An error occurred
            //NSLog(@"Error staging an image: %@", error);
            
            alertTitle = @"Share To Facebook Error";
            alertMessage = @"Error occored when uploading the game snapshot.";
            [rb showShareErrorWithTitle:alertTitle Message:alertMessage];
            
        }
    }];
}

-(void)showShareErrorWithTitle: (NSString *)alertTitle Message:(NSString *)alertMessage {
    
    GameViewController *controller = (GameViewController* )self.scene.view.window.rootViewController;
    controller.gameView.hidden = NO;
    [controller.loadingIcon stopAnimating];
    controller.loadingIcon.hidden = YES;
    
    [[[UIAlertView alloc] initWithTitle: alertTitle
                                message: alertMessage
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

@end
