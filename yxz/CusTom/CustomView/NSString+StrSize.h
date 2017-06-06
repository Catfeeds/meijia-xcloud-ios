//
//  NSString+StrSize.h
//  simi
//
//  Created by 赵中杰 on 14/12/2.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StrSize)

- (CGSize)returnMysizeWithCgsize:(CGSize)mysize font:(UIFont*)myfont;

- (NSString *)urlEncodeString;

@end
