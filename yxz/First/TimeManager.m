//
//  TimeManager.m
//  simi
//
//  Created by zrj on 15-1-14.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "TimeManager.h"

@implementation TimeManager
{
    NSDate *nowDates;
}
@synthesize KtimeOut;

- (void)TimeOutWith:(NSString *)TimeStr
{
    // 获得本地时间指定时区
    nowDates = [NSDate date];
    NSDateFormatter *formatter =  [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    [formatter setTimeZone:timeZone];
    NSString *loctime = [formatter stringFromDate:nowDates];
    NSLog(@"loctime:%@",loctime);
    NSDate *firstDate = [self stringToDate:loctime];

    NSTimeInterval  interval = 240*60;
    
    NSDate *s = [firstDate dateByAddingTimeInterval:+interval];
    
    NSString *f = [formatter stringFromDate:s];

    NSLog(@"%@",f);
    
    NSDate *secondDate = [self stringToDate:TimeStr];
    NSComparisonResult result = [s compare:secondDate];
   
    if (result == 1) { //不可以下单

        KtimeOut = YES;  //代表不可以下单
    
    }
    
}




- (NSDate *) stringToDate:string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:string];
    
    return date;
}
@end
