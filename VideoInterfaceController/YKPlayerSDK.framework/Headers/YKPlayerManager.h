//
//  YKPlayerManager.h
//  YKPlayerSDK
//
//  Created by SMY on 16/6/28.
//  Copyright © 2016年 SMY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "YKPlayerVideo.h"
#import "YKPlayerDelegate.h"
#import "YKPlayerDefine.h"

static const NSString *YK_PLAY_MODE = @"play_mode";
static const NSString *YK_VID = @"vid";
static const NSString *YK_URL = @"url";
static const NSString *YK_IS_HLS = @"is_hls";
static const NSString *YK_IS_LOCAL = @"is_local";
static const NSString *YK_DISPLAY_MODE = @"display_mode";
static const NSString *YK_SCALE = @"scale";
static const NSString *YK_QUALITY = @"quality";
static const NSString *YK_IS_AUTO_PLAY = @"is_auto_play";

@interface YKPlayerManager : NSObject

#pragma mark - init

+ (instancetype)sharedManager;

- (void)initAppKey:(NSString *)appKey andAppSecret:(NSString *)appSecret;
- (BOOL)checkAppKeyAndAppSecret;

#pragma mark - view

@property (nonatomic, assign, readonly) UIView *playerView;
@property (nonatomic, assign, readonly) CGRect playerViewRect;
@property (nonatomic, assign, readonly) AVPlayerLayer *playerLayer;
@property (nonatomic) YKPlayerDecodingScheme scheme;
@property (nonatomic) YKPlayerDisplayMode displayMode;
@property (nonatomic) float scale;

#pragma mark - play video control

@property (nonatomic, getter=isAutoPlay) BOOL autoPlay;
@property (nonatomic) YKPlayerVideoQuality quality;

- (void)playWithVid:(NSString *)vid;
- (void)playWithDict:(NSDictionary *)dict;

#pragma mark - play control

- (YKPlayerState)state;
- (void)start;
- (void)resume;
- (void)pause;
- (void)stop;
- (void)setEnableLoadData:(BOOL)enable;

#pragma mark - time control

- (NSTimeInterval)duration;
- (NSTimeInterval)currentTime;
- (NSTimeInterval)loadedTime;
- (void)seekToTime:(NSTimeInterval)time;

#pragma mark - destroy

- (void)releasePlayer;

#pragma mark - delegate

- (void)setYKPlayerDelegate:(id<YKPlayerDelegate>)delegate;

@end
