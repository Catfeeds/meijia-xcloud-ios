//
//  MyAccountView.m
//  simi
//
//  Created by 高鸿鹏 on 15/6/15.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "MyAccountView.h"

@implementation MyAccountView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        for (int i = 0 ; i < 7; i++) {
            UIButton *btn = [[UIButton alloc]init];
            btn.backgroundColor = [UIColor whiteColor];
            CGRect frame = i == 0? CGRectMake(0, 0, self_Width, 70): CGRectMake(0, 70+54*(i-1), self_height, 54);
            btn.backgroundColor = i==0 ? [UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1] :[UIColor greenColor];
            btn.frame = frame;
            [self addSubview:btn];
        }
        
    }
    return self;
}
@end
