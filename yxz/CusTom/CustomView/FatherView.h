//
//  FatherView.h
//  simi
//
//  Created by 赵中杰 on 14/11/28.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FatherView : UIView

//  得到color
-(UIColor *)getColor:(NSString *)hexColor;

//  返回高度
- (CGSize)returnMysizeWithCgsize:(CGSize)mysize text:(NSString*)mystring font:(UIFont*)myfont;

- (NSString *)getTimeWithstring:(NSTimeInterval)time;

@end
