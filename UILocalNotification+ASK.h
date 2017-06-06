//
//  UILocalNotification+ASK.h
//  换换圈
//
//  Created by RUIKAI LI on 15/6/3.
//  Copyright (c) 2015年 DF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILocalNotification (ASK)
+ (void)addNotificationWithTitle:(NSString *)title andMessage:(NSString *)message andTimeInterval:(NSTimeInterval)timeInterval andIdentifier:(NSString *)identifier;
+ (void)removeNotificationWithIdentifier:(NSString *)identifier;
@end
