//
//  YKPlayerViewDefine.h
//  YKPlayerViewSDK
//
//  Created by SMY on 16/9/8.
//  Copyright © 2016年 SMY. All rights reserved.
//

#ifndef YKPlayerViewDefine_h
#define YKPlayerViewDefine_h

typedef NS_ENUM (int, YKPlayerViewSkin) {
    YKPlayerViewSkinBlue = 0,
    YKPlayerViewSkinRed,
    YKPlayerViewSkinOrange,
    YKPlayerViewSkinGreen
};

typedef NS_ENUM(int, YKPlayerViewState) {
    YKPVPlayerStateError = 0,
    YKPVPlayerStateIdle,
    YKPVPlayerStatePreparing,
    YKPVPlayerStatePrepared,
    YKPVPlayerStatePlay,
    YKPVPlayerStatePause,
    YKPVPlayerStateStop,
    YKPVPlayerStateLoading,
    YKPVPlayerStateSeek,
    YKPVPlayerStateChangeQuality
};

#endif /* YKPlayerViewDefine_h */
