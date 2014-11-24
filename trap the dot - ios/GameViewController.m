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
#import <FacebookSDK/FacebookSDK.h>

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
    
    //[self checkIfCanDisplayAds];
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
    
    
    self.noAdsButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [self.noAdsButton setImage: [UIImage imageNamed: @"No-Ads"] forState:UIControlStateNormal];
    [self.noAdsButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.noAdsButton addTarget:self action:@selector(clickNoAds) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickNoAds {
    
}

- (void)showBannerView: (ADBannerView *)banner {
    banner.hidden = NO;
    
    [self.view addSubview: self.noAdsButton];
    
    [self.noAdsButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat: @"[_noAdsButton(==30)]" options:0 metrics:nil views: NSDictionaryOfVariableBindings(_noAdsButton)]];
    [self.noAdsButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat: @"V:[_noAdsButton(==30)]" options:0 metrics:nil views: NSDictionaryOfVariableBindings(_noAdsButton)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat: @"V:[_noAdsButton]-(2)-[_adView]" options: NSLayoutFormatAlignAllTrailing metrics:nil views: NSDictionaryOfVariableBindings(_noAdsButton, _adView)]];
}

- (void)hideBannerView: (ADBannerView *)banner {
    banner.hidden = YES;
    
    [self.noAdsButton removeFromSuperview];
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

@end
