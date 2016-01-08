//
//  FatherView.m
//  simi
//
//  Created by 赵中杰 on 14/11/28.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherView.h"

@implementation FatherView

#pragma mark 返回字符串高度
- (CGSize)returnMysizeWithCgsize:(CGSize)mysize text:(NSString*)mystring font:(UIFont*)myfont
{
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:myfont,NSFontAttributeName, nil];
    CGSize size = [mystring boundingRectWithSize:mysize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    return size;
}

#pragma mark 颜色值
-(UIColor *)getColor:(NSString *)hexColor
{
    unsigned int red, green, blue;
    NSRange range;
    range.length =2;
    
    range.location =0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    range.location =2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    range.location =4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green/255.0f)blue:(float)(blue/255.0f)alpha:1.0f];
}

- (NSString *)getTimeWithstring:(NSTimeInterval)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *theday = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *day = [dateFormatter stringFromDate:theday];
    
    return day;
}


@end
