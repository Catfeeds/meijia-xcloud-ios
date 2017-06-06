//
//  NSString+StrSize.m
//  simi
//
//  Created by 赵中杰 on 14/12/2.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "NSString+StrSize.h"

@implementation NSString (StrSize)

#pragma mark 返回字符串高度
- (CGSize)returnMysizeWithCgsize:(CGSize)mysize font:(UIFont*)myfont
{
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:myfont,NSFontAttributeName, nil];
    CGSize size = [self boundingRectWithSize:mysize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    return size;
}


- (NSString *)urlEncodeString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                             (CFStringRef)self,
                                                                                             NULL,
                                                                                             (CFStringRef)@";/?:@&=$+{}<>,*!()'",
                                                                                             kCFStringEncodingUTF8));
    return result;
}


@end
