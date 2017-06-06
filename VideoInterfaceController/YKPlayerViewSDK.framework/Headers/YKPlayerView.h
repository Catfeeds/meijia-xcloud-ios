//
//  YKPlayerView.h
//  YKPlayerViewSDK
//
//  Created by SMY on 16/9/8.
//  Copyright © 2016年 SMY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKPlayerViewDefine.h"

@protocol YKPlayerViewDelegate <NSObject>

- (void)onBackViewClick;

@end

@interface YKPlayerView : UIView

@property (nonatomic, weak) id<YKPlayerViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame andSkin:(YKPlayerViewSkin)skin;

- (void)initAppKey:(NSString *)key andAppSecret:(NSString *)secret;
- (void)setSkin:(YKPlayerViewSkin)skin;
- (void)setAutoPlay:(BOOL)autoPlay;
- (void)playWithVid:(NSString *)vid;
- (void)playWithDict:(NSDictionary *)dict;
- (void)start;
- (void)stop;
- (void)releasePlayer;

- (YKPlayerViewState)playerViewState;
@end
