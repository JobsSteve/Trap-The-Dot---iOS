//
//  GameViewController.h
//  Trap The Dot - ios
//

//  Copyright (c) 2014年 Reeonce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <iAd/iAd.h>
#import <FacebookSDK/FacebookSDK.h>

@interface GameViewController : UIViewController <ADBannerViewDelegate, FBLoginViewDelegate>

@property (nonatomic) ADBannerView *adView;
@property (nonatomic) SKView *gameView;
@property (nonatomic) UIButton *noAdsButton;
@property (nonatomic) BOOL areAdsRemoved;

@property (weak, nonatomic) IBOutlet UIView *FBView;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIcon;
@property (weak, nonatomic) IBOutlet UIButton *loginCloseButton;

- (void)configureBannerView;
- (void)checkIfCanDisplayAds;
- (void)loginToFB;
-(void)closeLoginView:(id)sender;

@end
