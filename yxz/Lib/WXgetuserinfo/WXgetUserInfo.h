//
//  WXgetUserInfo.h
//  simi
//
//  Created by 高鸿鹏 on 15/6/16.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXgetUserInfo : NSObject

+ (void)GetTokenWithCode:(NSString *)code;
+ (void)getUserInfoWithToken:(NSString *)token andOpenId:(NSString *)openid;
+ (void)SaveImgage:(UIImage *)image;

@end
