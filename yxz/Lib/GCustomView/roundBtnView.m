//
//  roundBtnView.m
//  simi
//
//  Created by zrj on 14-10-31.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "roundBtnView.h"
#import "ChoiceDefine.h"
@implementation roundBtnView

@synthesize delegate = _delegate;
- (id)initWithFrame:(CGRect)frame nameArray:(NSArray *)namearray
{
    self = [super initWithFrame:frame];
    if (self) {

        for (int i = 0; i <3; i ++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.frame = FRAME((2+60)*i, 0, 60, 45);
            [btn setTitle:[namearray objectAtIndex:i] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(roundAction:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 40+i;
            btn.titleLabel.numberOfLines = 0;
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn setTitleColor:HEX_TO_UICOLOR(ROUND_TITLE_COLOR, 1.0) forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn.layer setMasksToBounds:YES];
            [btn.layer setCornerRadius:5.0];//设置矩形四个圆角半径
            [btn setBackgroundColor:DEFAULT_COLOR];
            [self addSubview:btn];
            
            for (UIView *view in self.subviews){
                if ([view isKindOfClass:[UIButton class]]) {
                    if (view.tag == 40){
                        [(UIButton *)view setBackgroundColor:HEX_TO_UICOLOR(0xFFB30F, 1.0)];
                        [(UIButton *)view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [(UIButton *)view setBackgroundColor:DEFAULT_COLOR];
                        [(UIButton *)view setTitleColor:HEX_TO_UICOLOR(ROUND_TITLE_COLOR, 1.0) forState:UIControlStateNormal];
                    }
                }
            }

        }
    }
    
    return self;
}
- (void)roundAction:(UIButton *)sender
{
    
    [self.delegate RoundDelegate:sender.tag];
    
    if (sender.tag == 40) {
        for (UIView *view in self.subviews){
            if ([view isKindOfClass:[UIButton class]]) {
                if (view.tag == 40){
                    [(UIButton *)view setBackgroundColor:HEX_TO_UICOLOR(0xFFB30F, 1.0)];
                    [(UIButton *)view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
                else
                {
                    [(UIButton *)view setBackgroundColor:DEFAULT_COLOR];
                    [(UIButton *)view setTitleColor:HEX_TO_UICOLOR(ROUND_TITLE_COLOR, 1.0) forState:UIControlStateNormal];
                }
             }
        }

    }
    if (sender.tag == 41) {
        for (UIView *view in self.subviews){
            if ([view isKindOfClass:[UIButton class]]) {
                if (view.tag == 41){
                    [(UIButton *)view setBackgroundColor:HEX_TO_UICOLOR(0xFFB30F, 1.0)];
                    [(UIButton *)view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
                else
                {
                    [(UIButton *)view setBackgroundColor:DEFAULT_COLOR];
                    [(UIButton *)view setTitleColor:HEX_TO_UICOLOR(ROUND_TITLE_COLOR, 1.0) forState:UIControlStateNormal];
                }
            }
        }
        
    }
    if (sender.tag == 42) {
        for (UIView *view in self.subviews){
            if ([view isKindOfClass:[UIButton class]]) {
                if (view.tag == 42){
                    [(UIButton *)view setBackgroundColor:HEX_TO_UICOLOR(0xFFB30F, 1.0)];
                    [(UIButton *)view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
                else
                {
                    [(UIButton *)view setBackgroundColor:DEFAULT_COLOR];
                    [(UIButton *)view setTitleColor:HEX_TO_UICOLOR(ROUND_TITLE_COLOR, 1.0) forState:UIControlStateNormal];
                }
            }
        }
        
    }

}


@end
