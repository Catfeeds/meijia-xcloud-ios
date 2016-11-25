//
//  YKPlayerDefine.h
//  YKPlayerSDK
//
//  Created by SMY on 16/8/31.
//  Copyright © 2016年 SMY. All rights reserved.
//

typedef NS_ENUM(int, YKPlayerVideoQuality) {
    YKPlayerVideoSmooth = 0,    // 流畅
    YKPlayerVideoSD,            // 标清
    YKPlayerVideoHD,            // 高清
    YKPlayerVideoHD2,           // 超清
    YKPlayerVideoRAW,           // 原始
};

typedef NS_ENUM(int, YKPlayerEvent) {
    YKPlayerEventError = 0,
    YKPlayerEventPrepared,
    YKPlayerEventStart,
    YKPlayerEventStop,
    YKPlayerEventNetworkSpeed,
    YKPlayerEventLoadedTime,
    YKPlayerEventCurrentTime,
    YKPlayerEventBeginLoading,
    YKPlayerEventEndLoading,
    YKPlayerEventWillSwitchToQuality,
    YKPlayerEventDidSwitchToQuality,
    YKPlayerEventFailSwitchToQuality,
    YKPlayerEventSeekDone,
    YKPlayerEventSeekEnd
};

typedef NS_ENUM(int, YKPlayerDisplayMode) {
    YKPlayerDisplayModeResize = 0, // 全屏 占满屏幕
    YKPlayerDisplayModeAspect, // 保持原始比例
    YKPlayerDisplayModeResizeAspect, // 等比缩放 使一边占满屏幕
    YKPlayerDisplayModeModeResizeAspectFull // 全屏的等比
};

typedef NS_ENUM(int, YKPlayerState) {
    YKPlayerStateIdle = 0,
    YKPlayerStateError,
    YKPlayerStatePreparing,
    YKPlayerStatePrepared,
    YKPlayerStatePlay,
    YKPlayerStatePause,
    YKPlayerStateStop,
    YKPlayerStateLoading,
    YKPlayerStateSeek,
    YKPlayerStateChangeQuality,
};

typedef NS_ENUM(int, YKPlayerDecodingScheme) {
    YKPlayerDecodingSchemeSoftware,   // Support many media such as mp4, flv, avi, rmvb, mov ...
    YKPlayerDecodingSchemeHardwareGPU,
    YKPlayerDecodingSchemeHardwareYouku,  // Only support media whicth is a stream from Youku or download from Youku
    YKPlayerDecodingSchemeAVFoundation,       // Only support mp4, mov and Apple's HLS stream
};
