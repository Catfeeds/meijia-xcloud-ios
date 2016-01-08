//
//  UILocalNotification+ASK.m
//  换换圈
//
//  Created by RUIKAI LI on 15/6/3.
//  Copyright (c) 2015年 DF. All rights reserved.
//

#import "UILocalNotification+ASK.h"

#define IDENTIFIER @"ASK_EXCHANGER_IDENTIFIER"

@implementation UILocalNotification (ASK)

+ (void)addNotificationWithTitle:(NSString *)title andMessage:(NSString *)message andTimeInterval:(NSTimeInterval)timeInterval andIdentifier:(NSString *)identifier {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    if (localNotification) {
        localNotification.fireDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.alertBody = message;
        NSString *tempTitle = title? title : @"提醒";
        localNotification.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:identifier,IDENTIFIER,tempTitle,@"title", nil];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}

+ (void)removeNotificationWithIdentifier:(NSString *)identifier {
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    if (notifications.count != 0) {
        UILocalNotification *tempNotification = nil;
        for (UILocalNotification *notification in notifications) {
            NSString *tempIdentifier = [notification userInfo][IDENTIFIER];
            if ([identifier isEqualToString:tempIdentifier]) {
                tempNotification = notification;
            }
        }
        
        if (tempNotification) {
            [[UIApplication sharedApplication] cancelLocalNotification:tempNotification];
        }
    }
}

@end
