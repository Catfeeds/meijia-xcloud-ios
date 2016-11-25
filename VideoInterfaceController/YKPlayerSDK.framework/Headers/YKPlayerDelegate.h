//
//  YKPlayerDelegate.h
//  YKPlayerSDK
//
//  Created by SMY on 16/7/10.
//  Copyright © 2016年 SMY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YKPlayerDefine.h"

static const NSString *YK_DELEGATE_KEY_VIDEO = @"video";
static const NSString *YK_DELEGATE_KEY_ERROR_CODE = @"error_code";
static const NSString *YK_DELEGATE_KEY_SERVER_ERROR_CODE = @"server_error_code";
static const NSString *YK_DELEGATE_KEY_ERROR_MESSAGE = @"error_message";
static const NSString *YK_DELEGATE_KEY_SPEED = @"speed";
static const NSString *YK_DELEGATE_KEY_TIME = @"time";

@protocol YKPlayerDelegate <NSObject>

@required
- (void)ykplayerOnEventCallback:(YKPlayerEvent)event params:(NSDictionary *)params;

@end
