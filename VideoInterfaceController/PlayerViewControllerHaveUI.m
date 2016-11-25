//
//  PlayerViewControllerHaveUI.m
//  YKPlayerDemo
//
//  Created by SMY on 16/9/8.
//  Copyright © 2016年 SMY. All rights reserved.
//

#import "PlayerViewControllerHaveUI.h"
#import <YKPlayerViewSDK/YKPlayerViewSDK.h>

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define APP_KEY @"199b3f31e08d160c"
#define APP_SECRET @"08865c02e2f9dd9c7f11a72a02ddda9a"
//#define VID @"57ddfa1b0cf2394d3659a195"
@interface PlayerViewControllerHaveUI () <YKPlayerViewDelegate> {
    YKPlayerView *_playerView;
}
//self.appSecret = APP_SECRET;
//self.appKey = APP_KEY;
//self.vid = VID;

@end

@implementation PlayerViewControllerHaveUI

- (void)loadView {
    [super loadView];
   
    self.appSecret = APP_SECRET;
    self.appKey = APP_KEY;
//    self.vid = VID;
//    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
//
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"playbtn" object:nil];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _playerView = [[YKPlayerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH)];
    [_playerView setDelegate:self];
    [_playerView setSkin:YKPlayerViewSkinOrange];
    [self.view addSubview:_playerView];
//    [self deviceOrientationDidChange];
    
    
    UIButton * back = [[UIButton alloc]initWithFrame:CGRectMake(5, 5,40,40 )];
    [_playerView addSubview:back];
    [back addTarget:self action:@selector(onBackViewClick) forControlEvents:UIControlEventTouchDown];
}
//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft;
}

//一开始的方向  很重要
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeLeft;
}

//- (void)deviceOrientationDidChange
//{
//    NSLog(@"deviceOrientationDidChange:%ld",(long)[UIDevice currentDevice].orientation);

//    if([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
//        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
//        [self orientationChange:NO];
//        //注意： UIDeviceOrientationLandscapeLeft 与 UIInterfaceOrientationLandscapeRight
//    } else if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft) {
//        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
//        [self orientationChange:YES];
//    }
//}

//- (void)orientationChange:(BOOL)landscapeRight
//{
//    if (landscapeRight) {
//        [UIView animateWithDuration:0.2f animations:^{
//            self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
//            self.view.bounds = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//            _playerView = [[YKPlayerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
//        }];
//    } else {
//        [UIView animateWithDuration:0.2f animations:^{
//            self.view.transform = CGAffineTransformMakeRotation(0);
//            self.view.bounds = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//            _playerView = [[YKPlayerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
//        }];
//    }
//}
- (BOOL)shouldAutorotate
{
    return NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [_playerView initAppKey:self.appKey andAppSecret:self.appSecret];
    [_playerView setAutoPlay:NO];
    [_playerView playWithVid:self.vid];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [_playerView setNeedsLayout];
}

- (void)onBackViewClick {
    [_playerView stop];
    [_playerView releasePlayer];
    _playerView = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
