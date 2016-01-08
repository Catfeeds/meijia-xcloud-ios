//
//  BeiZhuViewController.m
//  simi
//
//  Created by zrj on 14-11-4.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "BeiZhuViewController.h"
#import "ChoiceDefine.h"
#import "BeiZhuManager.h"
@implementation BeiZhuViewController
{
    BeiZhuManager *model;
}
@synthesize delegate = _delegate,beizhu;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navlabel.text = @"备  注";
    self.backBtn.hidden = YES;
    
   UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"nav-arrow"] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    backBtn.frame = FRAME(18, (40-50/2)/2+25, 50/2, 50/2);
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    
    text = [[UITextView alloc]initWithFrame:FRAME(15, NAV_HEIGHT+15, SELF_VIEW_WIDTH-30, 180)];
    text.backgroundColor = [UIColor whiteColor];
    text.textAlignment = NSTextAlignmentLeft;
    text.editable = YES;
    text.text = beizhu;
    [self.view addSubview:text];
   
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = HEX_TO_UICOLOR(ROUND_COLOR, 1.0);
    btn.frame = FRAME(14, NAV_HEIGHT+15+200+15-20, SELF_VIEW_WIDTH-30, 108/2);
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(quedingAction) forControlEvents:UIControlEventTouchUpInside];
    [btn.layer setCornerRadius:5.0];//设置矩形四个圆角半径
    [self.view addSubview:btn];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dianji)];
    [self.view addGestureRecognizer:tap];
}
- (void)dianji{
    NSLog(@"123");
    [text resignFirstResponder];
}
- (void)backAction{

    [self.navigationController popViewControllerAnimated:YES];
}
- (void)quedingAction{
    [self.delegate BeiZhuDelegateLable:text.text];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
