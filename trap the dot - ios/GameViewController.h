//
//  GameViewController.h
//  Trap The Dot - ios
//

//  Copyright (c) 2014年 Reeonce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface GameViewController : UIViewController <ADBannerViewDelegate>

@property (nonatomic) ADBannerView *adView;
@property (nonatomic) SKView *gameView;
@property (nonatomic) UIButton *noAdsButton;
@property (nonatomic) BOOL areAdsRemoved;

- (IBAction)purchase;
- (IBAction)restore;
- (IBAction)tapsRemoveAdsButton;

- (void)configureBannerView;
- (void)checkIfCanDisplayAds;
@end
