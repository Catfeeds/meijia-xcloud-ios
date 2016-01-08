//
//  OrderTime.m
//  simi
//
//  Created by zrj on 15-1-26.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "OrderTime.h"

@implementation OrderTime

{
    NSDate *nowDates;
}

@synthesize KtimeOut;

- (BOOL)TimeOutWith:(NSString *)TimeStr hours:(NSInteger)hours
{
    // 获得本地时间指定时区
    nowDates = [NSDate date];
    NSDateFormatter *formatter =  [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYY-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    [formatter setTimeZone:timeZone];
    NSString *loctime = [formatter stringFromDate:nowDates];
    NSLog(@"loctime:%@",loctime);
    NSDate *firstDate = [self stringToDate:loctime];

    NSDate *secondDate = [self stringToDate:TimeStr];
    
    
    NSTimeInterval  interval = 60*hours*60;
    
    NSDate *s = [secondDate dateByAddingTimeInterval:+interval];
    
    NSString *f = [formatter stringFromDate:s];
    
    NSLog(@"%@",f);
    
    NSComparisonResult result = [firstDate compare:s];
    NSLog(@"result : %d",result);
    if (result == 1) { //不可以下单
        
        return YES;  //代表不可以下单
        
    }else{
        return NO;
    }
//    return YES;
}




- (NSDate *) stringToDate:string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYY-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:string];
    
    return date;
}
@end
