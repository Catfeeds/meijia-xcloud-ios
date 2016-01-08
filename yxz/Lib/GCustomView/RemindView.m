//
//  RemindView.m
//  simi
//
//  Created by zrj on 14-11-3.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "RemindView.h"
#import "ChoiceDefine.h"
#import "AppDelegate.h"
@implementation RemindView
@synthesize delegate = _delegate;
- (id)initWithFrame:(CGRect)frame labletext:(NSString *)str
{
    
    self = [super initWithFrame:frame];
    if (self) {
        top = YES;
        self.backgroundColor = HEX_TO_UICOLOR(BAC_VIEW_COLOR, 1.0);
        UIView *view = [[UIView alloc]initWithFrame:FRAME(0, 0, self_Width, 196/2+22)];
        view.backgroundColor = HEX_TO_UICOLOR(0xFFB30F, 1.0);
        [self addSubview:view];
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:FRAME(54/2, (50-44+10), self_Width-54, 137/2+20)];
        image.image = [UIImage imageNamed:@"oder-inform"];
        image.userInteractionEnabled = YES;
        [self addSubview:image];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = FRAME(232/2, (196+46)/2-176/2+10+10, 176/2, 176/2);
        [btn setBackgroundImage:[UIImage imageNamed:@"calling-btn"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"calling-btn-pressdown"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(callActiontoView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
//        _myscrollview = [[UIScrollView alloc]initWithFrame:FRAME(10, 5, (self_Width-54)-20, 20)];
//        _myscrollview.contentSize = CGSizeMake((self_Width-54)-20, 60);
//        _myscrollview.backgroundColor = [UIColor clearColor];
//        _myscrollview.delegate = self;
//        [image addSubview:_myscrollview];
//        
//        UILabel *lable = [[UILabel alloc]initWithFrame:FRAME(0, 0, (self_Width-54)-20, 20)];
//        lable.text = @"我待发哈看过哈开噶看明白卡第十八个 v 啊看到不过那看不惯你卡官方康卡";
//        lable.numberOfLines = 2;
//        lable.font = [UIFont systemFontOfSize:13];
//        lable.textColor = [UIColor whiteColor];
//        lable.textAlignment = NSTextAlignmentCenter;
//        [_myscrollview addSubview:lable];
        
        textview = [[UITextView alloc]initWithFrame:FRAME(10, 5, (self_Width-54)-20, 23)];
        textview.text =str;
        textview.font = [UIFont systemFontOfSize:12];
        textview.textColor = [UIColor whiteColor];
        textview.textAlignment = NSTextAlignmentCenter;
        textview.backgroundColor = [UIColor clearColor];
        textview.editable = NO;
        [image addSubview:textview];
        
         textTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(textscroll) userInfo:nil repeats:YES];
    }
    return self;
}
- (void)textscroll
{
    
    if (textview.text.length > 18) {
        

        if (top == YES) {
            [textview scrollRectToVisible:CGRectMake(10, textview.contentSize.height-20, textview.contentSize.width, 23) animated:YES];
            
            top = NO;
        }else
        {
            [textview scrollRectToVisible:CGRectMake(10, 0, textview.contentSize.width, 23) animated:YES];
            top = YES;
        }

        
    }else {

    }
    
    
    
}
#pragma mark 打电话
- (void)callActiontoView:(UIView *)view
{
    [self.delegate CallAction];

}
@end
