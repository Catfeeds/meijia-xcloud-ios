//
//  WeiXinPay.h
//  simi
//
//  Created by zrj on 15-4-30.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiXinPay : NSObject


+(void)sendAuthRequest;


+(void)pay:(NSString *)prepayId;
+(void)WXPaywithOrderNo:(NSString *)orderNo orderType:(NSString *)type;
+ (void)paySuccessOrFailWithOrderNo:(NSString *)orderNo orderType:(NSString *)type;
@end
