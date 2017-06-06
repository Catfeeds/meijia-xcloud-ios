//
//  SelectCityView.m
//  simi
//
//  Created by zrj on 14-10-31.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "SelectCityView.h"
#import "AppCommon.h"
@implementation SelectCityView
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame titleArray:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = YELLOW_COLOR;
        self.alpha = 0.8;
        self.userInteractionEnabled = YES;

        for (int i = 0; i < 2; i ++) {
            
            UIButton *touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            //            touchBtn.backgroundColor = [UIColor blackColor];
            [touchBtn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
            touchBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            touchBtn.frame = FRAME(0, 36*i, 75, 36);
            [touchBtn setTitleEdgeInsets:UIEdgeInsetsMake(11, 12, 12, 30)];
            [touchBtn addTarget:self action:@selector(SelectDress:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:touchBtn];
        }
        
        
    }
    return self;
}
- (void)SelectDress:(UIButton *)sender
{
    [self.delegate SelectCtiyDelegate:sender.currentTitle];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

