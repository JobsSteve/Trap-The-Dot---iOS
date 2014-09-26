//
//  ReeShareButtonNode.m
//  Circle The Dot
//
//  Created by Reeonce Zeng on 9/26/14.
//  Copyright (c) 2014 Reeonce. All rights reserved.
//

#import "ReeShareButtonNode.h"
#import <ShareSDK/ShareSDK.h>
#import "ReeCTDConfiguration.h"

@implementation ReeShareButtonNode {
    id<ISSContainer> container;
    UIButton *button;
}

- (void)addButtonToView: (UIView *)rView {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        button = [[UIButton alloc] initWithFrame:self.frame];
        [rView addSubview:button];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK"  ofType:@"jpg"];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"ShareSDK"
                                                  url:@"http://www.sharesdk.cn"
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeNews];
    if (!container && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        container = [ShareSDK container];
        [container setIPadContainerWithView:button arrowDirect:UIPopoverArrowDirectionLeft];
    } else {
        container = nil;
    }
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
}

@end
