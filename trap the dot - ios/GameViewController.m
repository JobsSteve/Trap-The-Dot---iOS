//
//  GameViewController.m
//  Trap The Dot - ios
//
//  Created by Reeonce on 14-9-18.
//  Copyright (c) 2014年 Reeonce. All rights reserved.
//

#import <iAd/iAd.h>
#import "GameViewController.h"
#import "GameScene.h"
#import <AFNetworking/AFNetworking.h>
#import "ReeTTDConfiguration.h"
#import <UIKit/UIKit.h>

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure the view.
    
    _gameView = [[SKView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_gameView];
    
    SKView * skView = (SKView *)_gameView;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    
    // Create and configure the scene.
    GameScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    //scene.preferredInterfaceOrientationForPresentation = self.preferredInterfaceOrientationForPresentation;
    scene.preferredInterfaceOrientationForPresentation = UIInterfaceOrientationPortrait;
    // Present the scene.
    [skView presentScene:scene];
    
    [self configureBannerView];
    
    
    FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions: @[@"public_profile", @"publish_actions"]];
    loginView.delegate = self;
    [loginView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.FBView addSubview:loginView];
    UIView *profile = self.profilePictureView;
    [self.FBView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[profile]-(10)-[loginView]" options:0 metrics:nil views: NSDictionaryOfVariableBindings(profile, loginView)]];
    [self.FBView addConstraint:[NSLayoutConstraint constraintWithItem:self.FBView attribute:(NSLayoutAttributeCenterX) relatedBy:(NSLayoutRelationEqual) toItem:loginView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self.loginCloseButton addTarget:self action:@selector(closeLoginView:) forControlEvents:UIControlEventTouchUpInside];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    SKView * skView = (SKView *)self.view;
    GameScene *scene = (GameScene *)skView.scene;
    [scene doRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (void)checkIfCanDisplayAds {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URLString = (NSString *)[ReeTTDConfiguration getValueWithKey: @"webDataUrl"];
    [manager GET: URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        BOOL canDisplayAdds = [[responseObject valueForKey: @"canDisplayAdds"] boolValue];
        if (canDisplayAdds) {
            [self configureBannerView];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        return;
    }];
}

- (void)configureBannerView {
    
    self.adView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    self.adView.delegate = self;
    self.adView.frame = CGRectMake(0, self.view.frame.size.height - self.adView.frame.size.height, self.adView.frame.size.width, self.adView.frame.size.height);
    self.adView.hidden = YES;
    [self.view addSubview:self.adView];
    
    /* * *
    self.noAdsButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [self.noAdsButton setImage: [UIImage imageNamed: @"No-Ads"] forState:UIControlStateNormal];
    [self.noAdsButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.noAdsButton addTarget:self action:@selector(clickNoAds) forControlEvents:UIControlEventTouchUpInside];
     * * */
}

- (void)clickNoAds {
    
}

- (void)showBannerView: (ADBannerView *)banner {
    banner.hidden = NO;
    
    /* * *
    [self.view addSubview: self.noAdsButton];
    
    [self.noAdsButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat: @"[_noAdsButton(==30)]" options:0 metrics:nil views: NSDictionaryOfVariableBindings(_noAdsButton)]];
    [self.noAdsButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat: @"V:[_noAdsButton(==30)]" options:0 metrics:nil views: NSDictionaryOfVariableBindings(_noAdsButton)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat: @"V:[_noAdsButton]-(2)-[_adView]" options: NSLayoutFormatAlignAllTrailing metrics:nil views: NSDictionaryOfVariableBindings(_noAdsButton, _adView)]];
    * * */
}

- (void)hideBannerView: (ADBannerView *)banner {
    banner.hidden = YES;
    
    //[self.noAdsButton removeFromSuperview];
}

- (void)removeBannerView {
    self.canDisplayBannerAds = NO;
    
    if (_adView != nil) {
        if (_adView.superview) {
            [_adView removeFromSuperview];
        }
        _adView.delegate = nil;
        _adView = nil;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    [self hideBannerView:banner];
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner {
    [self showBannerView:banner];
}

-(void)bannerViewWillLoadAd:(ADBannerView *)banner {
    
}

-(void)bannerViewActionDidFinish:(ADBannerView *)banner {
}

-(void)loginToFB {
    self.FBView.hidden = NO;
    self.gameView.hidden = YES;
}

-(void)continuePlayGame {
    self.FBView.hidden = YES;
    self.gameView.hidden = NO;
}

-(void)closeLoginView:(id)sender {
    [UIView animateWithDuration:1 animations:^{
        self.FBView.frame = CGRectMake(0, self.FBView.frame.size.height, self.FBView.frame.size.width, self.FBView.frame.size.height);
        self.gameView.hidden = NO;
    } completion:^(BOOL finished) {
        self.FBView.hidden = YES;
        self.FBView.frame = CGRectMake(0, 0, self.FBView.frame.size.width, self.FBView.frame.size.height);
    }];
}

// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    self.profilePictureView.profileID = user.objectID;
    self.nameLabel.text = user.name;
}

// Logged-in user experience
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    [self continuePlayGame];
    self.statusLabel.text = @"You're logged in as";
}

// Logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    self.profilePictureView.profileID = nil;
    self.nameLabel.text = @" ";
    self.statusLabel.text= @"You're not logged in!";
}

// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;

    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

@end
